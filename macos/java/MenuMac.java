package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.Native;
import org.jetbrains.annotations.ApiStatus;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NotNull;

public class MenuMac extends Menu {
    @ApiStatus.Internal
    public MenuMac() {
        super(_nMake());
    }

    @ApiStatus.Experimental @NotNull @Contract("-> this")
    public MenuMac addItem(MenuItemMac menuItem) {
        _nAddItem(menuItem);
        menuItem._setParentMenu(this);
        return this;
    }

    @ApiStatus.Internal @NotNull @Contract("-> this")
    public MenuMac _setSubMenu(MenuMac subMenu, MenuItemMac forItem) {
        _nSetSubmenu(subMenu, forItem);
        return this;
    }

    @ApiStatus.Experimental
    public static void setApplicationMenu(MenuMac menu) {
        _nSetApplicationMenu(menu);
    }

    @ApiStatus.Internal public native void _nSetTitle(String title);

    @ApiStatus.Internal public native void _nAddItem(MenuItemMac itemObj);

    @ApiStatus.Internal public native void _nSetSubmenu(MenuMac subMenu, MenuItemMac itemObj);

    @ApiStatus.Internal public static native long _nMake();

    @ApiStatus.Internal public static native void _nSetApplicationMenu(MenuMac menu);
}
