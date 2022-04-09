package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.Native;
import org.jetbrains.annotations.ApiStatus;

public class MenuMac extends Menu {
    @ApiStatus.Internal
    public MenuMac() {
        super(_nMake());
    }

    @ApiStatus.Experimental
    public void addItem(MenuItemMac menuItemMac) {
        _nAddItem(menuItemMac);
    }

    @ApiStatus.Experimental
    public static void setApplicationMenu(MenuMac menu) {
        _nSetApplicationMenu(Native.getPtr(menu));
    }

    @ApiStatus.Internal public native void _nAddItem(MenuItemMac menuItem);


    @ApiStatus.Internal public static native long _nMake();

    @ApiStatus.Internal public static native long _nSetApplicationMenu(long ptr);
}
