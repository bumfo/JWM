#include <jni.h>
#include "Menu.hh"

jwm::Menu::~Menu() {
    fEnv->DeleteGlobalRef(fMenu);
}

/*
 * Class:     io_github_humbleui_jwm_Menu
 * Method:    _nInit
 * Signature: ()V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_Menu__1nInit
        (JNIEnv *env, jobject obj) {
    printf("Menu._nInit\n");
    jwm::Menu *instance = reinterpret_cast<jwm::Menu *>(jwm::classes::Native::fromJava(env, obj));
    instance->fMenu = env->NewGlobalRef(obj);
}
