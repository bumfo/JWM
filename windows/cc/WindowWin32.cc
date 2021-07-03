#include <PlatformWin32.hh>
#include <AppWin32.hh>
#include <WindowWin32.hh>
#include <WindowManagerWin32.hh>
#include <impl/Library.hh>
#include <memory>

jwm::WindowWin32::WindowWin32(JNIEnv *env, struct WindowManagerWin32 &windowManagerWin32)
        : Window(env), _windowManager(windowManagerWin32) {

}

jwm::WindowWin32::~WindowWin32() {
    if (_hWnd) {
        _windowManager._unregisterWindow(*this);
        _hWnd = NULL;
    }
}

bool jwm::WindowWin32::init() {
    DWORD style = _getWindowStyle();
    DWORD exStyle = _getWindowExStyle();

    int x = CW_USEDEFAULT;
    int y = CW_USEDEFAULT;
    int width = CW_USEDEFAULT;
    int height = CW_USEDEFAULT;

    HWND hWndParent = NULL;
    HMENU hMenu = NULL;
    HINSTANCE hInstance = GetModuleHandle(NULL);
    LPVOID lpParam = NULL;

    _hWnd = CreateWindowExW(
            exStyle,
            JWM_WIN32_WINDOW_CLASS_NAME,
            JWM_WIN32_WINDOW_DEFAULT_NAME,
            style,
            x, y,
            width, height,
            hWndParent,
            hMenu,
            hInstance,
            lpParam
    );

    if (!_hWnd) {
        _windowManager.sendError("Failed to init WindowWin32");
        return JWM_FALSE;
    }

    // Set this as property to reference from message callbacks
    SetPropW(_hWnd, L"JWM", this);

    // Register window, so manager can process its update
    _windowManager._registerWindow(*this);

    return JWM_TRUE;
}

void jwm::WindowWin32::show() {
    ShowWindow(_hWnd, SW_SHOWNA);
}

void jwm::WindowWin32::getPosition(int &left, int &top) const {

}

int jwm::WindowWin32::getLeft() const {
    int left, top;
    getPosition(left, top);
    return left;
}

int jwm::WindowWin32::getTop() const {
    int left, top;
    getPosition(left, top);
    return top;
}

int jwm::WindowWin32::getWidth() const {
    return 0;
}

int jwm::WindowWin32::getHeight() const {
    return 0;
}

float jwm::WindowWin32::getScale() const {
    return 1.0f;
}

void jwm::WindowWin32::move(int left, int top) {

}

void jwm::WindowWin32::resize(int width, int height) {

}

void jwm::WindowWin32::close() {

}

DWORD jwm::WindowWin32::_getWindowStyle() const {
    return WS_OVERLAPPEDWINDOW;
}

DWORD jwm::WindowWin32::_getWindowExStyle() const {
    return 0;
}

// JNI

extern "C" JNIEXPORT jlong JNICALL Java_org_jetbrains_jwm_WindowWin32__1nMake
        (JNIEnv* env, jclass jclass) {
    std::unique_ptr<jwm::WindowWin32> instance(new jwm::WindowWin32(env, jwm::AppWin32::getInstance().getWindowManager()));
    if (instance->init())
        return reinterpret_cast<jlong>(instance.release());
    else
        return 0;
}

extern "C" JNIEXPORT void JNICALL Java_org_jetbrains_jwm_WindowWin32_show
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    instance->show();
}

extern "C" JNIEXPORT jint JNICALL Java_org_jetbrains_jwm_WindowWin32_getLeft
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    return instance->getLeft();
}

extern "C" JNIEXPORT jint JNICALL Java_org_jetbrains_jwm_WindowWin32_getTop
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    return instance->getTop();
}

extern "C" JNIEXPORT jint JNICALL Java_org_jetbrains_jwm_WindowWin32_getWidth
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    return instance->getWidth();
}

extern "C" JNIEXPORT jint JNICALL Java_org_jetbrains_jwm_WindowWin32_getHeight
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    return instance->getHeight();
}

extern "C" JNIEXPORT jfloat JNICALL Java_org_jetbrains_jwm_WindowWin32_getScale
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    return instance->getScale();
}

extern "C" JNIEXPORT void JNICALL Java_org_jetbrains_jwm_WindowWin32_move
        (JNIEnv* env, jobject obj, int left, int top) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    instance->move(left, top);
}

extern "C" JNIEXPORT void JNICALL Java_org_jetbrains_jwm_WindowWin32_resize
        (JNIEnv* env, jobject obj, int width, int height) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    instance->resize(width, height);
}

extern "C" JNIEXPORT void JNICALL Java_org_jetbrains_jwm_WindowWin32_requestFrame
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
}

extern "C" JNIEXPORT void JNICALL Java_org_jetbrains_jwm_WindowWin32__1nClose
        (JNIEnv* env, jobject obj) {
    jwm::WindowWin32* instance = reinterpret_cast<jwm::WindowWin32*>(jwm::classes::Native::fromJava(env, obj));
    instance->close();
}