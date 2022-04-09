package io.github.humbleui.jwm;

import org.jetbrains.annotations.ApiStatus;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NotNull;

public class MenuItemMac extends MenuItem {
    @ApiStatus.Internal public String _title;
    @ApiStatus.Internal public MenuMac _parentMenu;
    @ApiStatus.Internal public MenuMac _submenu;

    @ApiStatus.Experimental
    public MenuItemMac() {
        super(_nMake());
    }

    @ApiStatus.Experimental @NotNull @Contract("-> this")
    public MenuItemMac setTitle(String title) {
        _title = title;
        return _updateTitle();
    }

    @ApiStatus.Experimental @NotNull @Contract("-> this")
    public MenuItemMac setSubmenu(MenuMac submenu) {
        _submenu = submenu;
        return _updateTitle()._updateSubmenu();
    }

    @ApiStatus.Internal @NotNull @Contract("-> this")
    public MenuItemMac _setParentMenu(MenuMac parentMenu) {
        _parentMenu = parentMenu;
        return _updateSubmenu();
    }

    @ApiStatus.Internal @NotNull @Contract("-> this")
    public MenuItemMac _updateSubmenu() {
        if (_parentMenu != null && _submenu != null) {
            _parentMenu._setSubMenu(_submenu, this);
        }
        return this;
    }

    @ApiStatus.Internal @NotNull @Contract("-> this")
    public MenuItemMac _updateTitle() {
        if (_title != null) {
            _nSetTitle(_title);
            if (_submenu != null) {
                _submenu._nSetTitle(_title);
            }
        }
        return this;
    }

    @ApiStatus.Internal public native void _nSetTitle(String title);

    @ApiStatus.Internal public static native long _nMake();
}
