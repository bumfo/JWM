#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuMac.hh"

jwm::MenuMac::~MenuMac() {}

bool jwm::MenuMac::init() {
    NSLog(@"MenuMac - init");

    return true;
}

/*
 * Class:     io_github_humbleui_jwm_MenuMac
 * Method:    _nMake
 * Signature: ()J
 */
extern "C" JNIEXPORT jlong JNICALL Java_io_github_humbleui_jwm_MenuMac__1nMake
        (JNIEnv *env, jclass) {
    NSLog(@"MenuMac._nMake");
    std::unique_ptr<jwm::MenuMac> instance(new jwm::MenuMac(env));
    if (instance->init()) {
        return reinterpret_cast<jlong>(instance.release());
    } else {
        return 0;
    }
}

/*
 * Class:     io_github_humbleui_jwm_MenuMac
 * Method:    _nSetApplicationMenu
 * Signature: (J)J
 */
extern "C" JNIEXPORT jlong JNICALL Java_io_github_humbleui_jwm_MenuMac__1nSetApplicationMenu
        (JNIEnv *, jclass, jlong) {
    NSLog(@"MenuMac._nSetApplicationMenu");
    return 0;
}
