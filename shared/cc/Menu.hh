#pragma once

#include <jni.h>
#include "impl/Library.hh"
#include "impl/RefCounted.hh"

namespace jwm {
    class Menu: public RefCounted {
    public:
        // Menu(JNIEnv* env): fEnv(env) {
        // }

        virtual ~Menu();

        // JNIEnv* fEnv = nullptr;
        // jobject fMenu = nullptr;
    };
}