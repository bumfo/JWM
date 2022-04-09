package io.github.humbleui.jwm;

import io.github.humbleui.jwm.impl.RefCounted;
import org.jetbrains.annotations.ApiStatus;

public abstract class MenuItem extends RefCounted {
    @ApiStatus.Internal
    public MenuItem(long ptr) {
        super(ptr);
        _nInit();
    }

    @ApiStatus.Internal public native void _nInit();
}
