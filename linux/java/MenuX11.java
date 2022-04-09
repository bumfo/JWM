package io.github.humbleui.jwm;

import org.jetbrains.annotations.ApiStatus;

public class MenuX11 extends Menu {
    @ApiStatus.Internal
    public MenuX11() {
        super(_nMake());
    }

    @ApiStatus.Internal public static native long _nMake();
}
