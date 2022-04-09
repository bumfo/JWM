package io.github.humbleui.jwm;

import org.jetbrains.annotations.ApiStatus;

public class MenuMac extends Menu {
    @ApiStatus.Internal
    public MenuMac() {
        super(_nMake());
    }

    @ApiStatus.Internal public static native long _nMake();

    @ApiStatus.Internal public static native long _nSetApplicationMenu(long ptr);
}
