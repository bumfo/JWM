package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.Native;
import io.github.humbleui.jwm.impl.RefCounted;
import org.jetbrains.annotations.ApiStatus;

public class MenuItemMac extends RefCounted {
    @ApiStatus.Experimental
    public MenuItemMac() {
        super(_nMake());
    }

    @ApiStatus.Experimental
    public void setSubMenu(MenuMac menu) {
        _nSetSubMenu(Native.getPtr(menu));
    }

    @ApiStatus.Internal public static native long _nMake();

    @ApiStatus.Internal public native long _nSetSubMenu(long ptr);
}
