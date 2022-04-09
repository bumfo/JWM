package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.RefCounted;
import org.jetbrains.annotations.ApiStatus;

public abstract class Menu extends RefCounted {
    @ApiStatus.Internal
    public Menu(long ptr) {
        super(ptr);
        _nInit();
    }

    @ApiStatus.Internal public native void _nInit();
}
