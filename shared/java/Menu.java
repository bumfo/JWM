package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.RefCounted;
import lombok.SneakyThrows;
import org.jetbrains.annotations.ApiStatus;
import org.jetbrains.annotations.NotNull;

public abstract class Menu extends RefCounted {
    // @ApiStatus.Internal
    // public static List<Menu> _menus = Collections.synchronizedList(new ArrayList<Menu>());

    @ApiStatus.Internal
    public Menu(long ptr) {
        super(ptr);
        _nInit();
    }

    @NotNull @SneakyThrows
    public static Menu make() {
        assert App._onUIThread();
        Menu menu;
        if (Platform.CURRENT == Platform.WINDOWS)
            menu = new MenuWin32();
        else if (Platform.CURRENT == Platform.MACOS)
            menu = new MenuMac();
        else if (Platform.CURRENT == Platform.X11)
            menu = new MenuX11();
        else
            throw new RuntimeException("Unsupported platform: " + Platform.CURRENT);
        // _menus.add(menu);
        return menu;
    }

    @ApiStatus.Internal public native void _nInit();
}
