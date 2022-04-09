#pragma once

#include <jni.h>
#include "impl/Library.hh"
#include "impl/RefCounted.hh"

namespace jwm {
    class MenuItem: public RefCounted {
    public:
        MenuItem(JNIEnv* env): fEnv(env) {
        }

        virtual ~MenuItem();

        JNIEnv* fEnv = nullptr;
        jobject fMenuItem = nullptr;
    };
}