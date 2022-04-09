#include <jni.h>
#include "MenuItem.hh"

jwm::MenuItem::~MenuItem() {
    // fEnv->DeleteGlobalRef(fMenuItem);
}

/*
 * Class:     io_github_humbleui_jwm_MenuItem
 * Method:    _nInit
 * Signature: ()V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuItem__1nInit
        (JNIEnv* env, jobject obj) {
    printf("MenuItem._nInit\n");
    // jwm::MenuItem* instance = reinterpret_cast<jwm::MenuItem*>(jwm::classes::Native::fromJava(env, obj));
    // instance->fMenuItem = env->NewGlobalRef(obj);
}
