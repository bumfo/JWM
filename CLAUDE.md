# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

JWM is a cross-platform Java window-management/OS-integration library. Native code lives per platform (`macos/`, `windows/`, `linux/`), exposed to Java via JNI. The status matrix in `README.md` is the authoritative list of what is implemented on which platform.

## Build / run

The Python scripts in `script/` are the canonical entry points — there is no Maven/Gradle build at the repo root (CMake builds the native lib, `script/build.py` orchestrates everything and calls `javac` directly via `script/build_utils.py`).

```sh
python3 script/build.py                         # build native lib + Java classes
python3 script/build.py --only native           # CMake/Ninja build of the platform .dylib/.dll/.so
python3 script/build.py --only java             # compile Java sources only
python3 script/build.py --arch=x64              # cross-arch on macOS (also: --arch=arm64)
python3 script/run.py                           # build + run the `dashboard` example
python3 script/run.py --example empty           # run a different example from examples/
python3 script/run.py --jwm-version 0.4.24      # run examples against a released JWM from Maven (skip local build)
python3 script/run.py --skija-dir ../Skija      # run examples against a local Skija checkout
python3 script/clean.py                         # remove build/target dirs
```

Prerequisites: Git, CMake 3.11+, Ninja, a C++ compiler, JDK 11+, `$JAVA_HOME`, Python 3. Windows needs MSVC (run from the x64 Native Tools Command Prompt). Ubuntu needs `libxcomposite-dev libxrandr-dev libgl1-mesa-dev libxi-dev libxcursor-dev`.

There is no test suite. Verify changes by running an example (`script/run.py`) and exercising the affected feature manually.

### Consuming an unreleased patch from a downstream project

`script/build.py` only writes `target/classes/` locally; the Maven Central JAR is assembled in CI. Downstream Gradle/Maven projects can pin against the directory directly:

```groovy
implementation files("/abs/path/to/jwm/target/classes")
```

`impl/Library.java` loads the platform native lib (`libjwm_<arch>.dylib` / `jwm_x64.dll` / `libjwm_x64.so`) from the same classpath root at runtime, so no extra wiring is needed. Useful for end-to-end testing a JWM patch in a downstream app before opening a PR.

## Architecture

### Code layout

- `shared/java/` — public Java API in `io.github.humbleui.jwm`; impl helpers in `io.github.humbleui.jwm.impl`; optional Skija integration in `io.github.humbleui.jwm.skija` (`shared/java/skija/`).
- `shared/cc/` — platform-agnostic C++ glue (`Window.cc`, `Log.cc`, `StringUTF16.cc`) plus JNI registration in `impl/Library.cc`.
- `macos/`, `windows/`, `linux/` — each has `java/` for platform-specific Java (e.g. `WindowMac.java`, `LayerMetal.java`) and `cc/` for the native implementation. macOS uses Objective-C++ (`*.mm`); Windows/Linux use plain C++.
- `examples/dashboard/java/` — primary example app exercising most features; `examples/empty/` is the minimal reference.
- `script/` — build orchestration (Python).
- `target/classes/` — `script/build.py` output (Java `.class` files plus the platform-named native lib `libjwm_arm64.dylib` / `jwm_x64.dll` / `libjwm_x64.so`). The native lib is shipped *inside* the JAR and extracted at runtime by `impl/Library.java`.

### Build model

`shared/CMakeLists.txt` does not exist on its own — each platform's `CMakeLists.txt` (e.g. `macos/CMakeLists.txt`) globs `shared/cc/*.cc` + its own `cc/*.{mm,cc}` and produces a single `jwm_<arch>` shared library. Top-level `CMakeLists.txt` only forwards to the platform subdir matching the host OS (it exists mostly so CLion can index the project).

Java compilation is one `javac` invocation over all four source roots (`shared/java`, `linux/java`, `macos/java`, `windows/java`). Platform `Window*`/`Layer*` classes coexist in the same compile unit; the wrong-platform sources still compile because they don't reference platform-specific JDK APIs at compile time.

### Dispatch and threading

- `App.start(launcher)` initializes JNI, loads the native library (`impl/Library.java` extracts the right `.dylib`/`.dll`/`.so` from the JAR into a temp dir), records the UI thread id, and runs the launcher on that thread. The event loop runs after `launcher.run()` returns.
- `App.makeWindow()` picks the right concrete `Window` subclass based on `Platform.CURRENT` (`WindowMac` / `WindowWin32` / `WindowX11`). Same for `Layer*` classes.
- All JWM API calls (except `App.runOnUIThread`) must happen on the UI thread; many methods `assert _onUIThread()`. From any other thread, use `App.runOnUIThread(Runnable)`.
- Native side: `jwm::Window` (`shared/cc/Window.hh`) holds a `JNIEnv*` plus a global ref to the Java `Window`. Events are dispatched by calling `Window.accept(Event)` from C++ via `jwm::classes::Consumer::accept`. JNI method bindings live in `Java_io_github_humbleui_jwm_*` exports in the platform `.mm`/`.cc` files.
- Rendering is on-demand and v-synced: client calls `window.requestFrame()`, JWM eventually delivers an `EventFrame` (or `EventFrameSkija` when a `Layer*Skija` is attached), the listener paints and may request another frame.
- macOS-specific: `WindowMac.setVisible(true)` synchronously dispatches `EventWindowScreenChange` (via `super.setVisible(true)`), even when the window was already visible. Layer-reconfigure work piggybacks on that event. New code that hooks visibility transitions should match the pattern.

#### macOS frame loop / CVDisplayLink lifecycle

`WindowMac.mm` runs a small state machine over five fields. They are tightly coupled — read `setVisible`, `requestFrame`, and `displayLinkCallback` together before touching any of them.

| Field | Owner / meaning |
|-------|-----------------|
| `fDisplayLink` | The `CVDisplayLinkRef`. Created in `setVisible(true)`, released + zeroed in `setVisible(false)`. |
| `fDisplayLinkRunning` | Whether `CVDisplayLinkStart` is in effect. **Must be reset to `false` whenever the link is released or recreated.** Since 0.4.18 (commit 5cdda76) `displayLinkCallback` no longer clears this between ticks, so `setVisible(false)` is the only remaining place. Forgetting the reset leaves the next `setVisible(true)` + `requestFrame()` cycle stuck — the new link is created but never started. (See PR #305 for the regression.) |
| `fFrameRequested` | Client asked for a frame. Cleared inside `displayLinkCallback` just before dispatching `EventFrame`. |
| `fFrameScheduled` | A `dispatch_async` block for the next frame is already queued. Prevents the callback from posting multiple frames per tick. |
| `fVisible` | Mirror of the last `setVisible` argument. Gated by the `fDisplayLinkMutex`. |

`requestFrame()` is the only place that calls `CVDisplayLinkStart`, and it short-circuits on `fVisible && !fDisplayLinkRunning`. If either flag is stale relative to the actual `fDisplayLink`, no `EventFrame` is dispatched and the window appears frozen until the user toggles visibility again.

#### Native refcounting around async callbacks

The C++ `WindowMac` is reference-counted (`shared/cc/impl/RefCounted.cc`). Any code path that hands a `this` pointer to a system callback must pin the lifetime explicitly:

- `setVisible(true)` does `ref()` to keep the window alive across `CVDisplayLink` callbacks; `setVisible(false)` (and `close()`) does the matching `unref()`.
- `displayLinkCallback` does `ref()` before `dispatch_async` and `unref()` inside the dispatched block.

New async code (system framework callbacks, `dispatch_async`, GCD timers, etc.) needs the same pattern. Skipping it produces use-after-free crashes that only show up when the window closes during an in-flight callback.

### Skija integration

The `LayerGLSkija` / `LayerMetalSkija` / `LayerRasterSkija` classes wrap a regular `Layer*` and synthesize an `EventFrameSkija` carrying a Skija `Surface` already sized to the current backing store. JWM doesn't depend on Skija — those classes only compile because Skija is pulled in via Maven during the build (`common.py` → `deps_compile`). Clients who want to use them must add Skija to their own classpath.

### Coordinates / DPI

API is in unscaled physical pixels, origin top-left, with screen positions in one absolute coordinate space across all monitors. DPI is fractional and exposed via `Screen.getScale()`; clients are responsible for scaling logical sizes themselves (this matters most on macOS, where the convention is the opposite). See `docs/Getting Started.md`.

## Conventions (from `docs/Conventions.md`)

These are enforced informally throughout the codebase — match them in new code:

- C++ files are `*.cc` / `*.hh`; everything in `namespace jwm`. Java public API in `io.github.humbleui.jwm`, impl in `io.github.humbleui.jwm.impl`. No inner classes.
- camelCase Java + C++; UPPER_CASE for enum values.
- Method/field prefixes: `_n...` for native methods (e.g. `_nGetScreens`), leading `_` for "private but public-for-clients" fields/methods (also tagged `@ApiStatus.Internal`), `get.../is...` for getters, `set.../with...` for setters (return `this`), `make...` for static constructors, `_FLAG_<TYPE>_<NAME>` for bit flags, `...Mask` for bit masks.
- Class names use `<Generic><Specific>` so they sort together: `EventKey` not `KeyEvent`, `WindowMac` not `MacWindow`.
- Visibility: everything is `public`. Things not meant for normal client use get an `_` prefix + `@ApiStatus.Internal` rather than `private` (intentional — see the rationale in `docs/Conventions.md`).
- Data classes use Lombok `@Data` with public-final `_`-prefixed fields plus JavaBeans getters. Flags are not exposed directly; expose `isFoo()` per flag.
- JNI conventions: native methods are `public static native` with `_n` + Java name; enums passed as ints (order must match between Java and C++); pointers as `jlong`; unroll small fixed objects (`Rect` → 4× `jfloat`); two ints fit in one `jlong`. Prefer `Native.ptr(obj)` over `obj._ptr`.

## Release

Tags matching `N.N.N` trigger `.github/workflows/build.yml`, which builds native libs on three runners, fuses them with the Java classes into a single JAR, and publishes to Maven Central (`io.github.humbleui:jwm`). `CHANGELOG.md` must have a `# <version>` section — `script/build_utils.py:release_notes` extracts it into `RELEASE_NOTES.md` for the GitHub release.
