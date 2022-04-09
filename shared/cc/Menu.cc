#include <jni.h>
#include "Menu.hh"

jwm::Menu::~Menu() {
}

/*
 * Class:     io_github_humbleui_jwm_Menu
 * Method:    _nInit
 * Signature: ()V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_Menu__1nInit
  (JNIEnv *, jobject) {
    printf("Menu._nInit\n");
  }
