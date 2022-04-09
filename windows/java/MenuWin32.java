package io.github.humbleui.jwm;

import org.jetbrains.annotations.ApiStatus;

public class MenuWin32 extends Menu {
    @ApiStatus.Internal
    public MenuWin32() {
        super(_nMake());
    }

    @ApiStatus.Internal public static native long _nMake();
}
