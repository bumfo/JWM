package io.github.humbleui.jwm;

import org.jetbrains.annotations.ApiStatus;

public class MenuItemMac extends MenuItem {
    @ApiStatus.Experimental
    public MenuItemMac() {
        super(_nMake());
    }

    @ApiStatus.Internal public static native long _nMake();
}
