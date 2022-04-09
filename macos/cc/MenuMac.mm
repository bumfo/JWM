#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuMac.hh"
#include "MenuItemMac.hh"

jwm::MenuMac::~MenuMac() {
    NSLog(@"MenuMac - release");
    [fNSMenu release];
}

bool jwm::MenuMac::init() {
    NSLog(@"MenuMac - init");

    fNSMenu = [[NSMenu alloc] initWithTitle:@"Menu"];

    return true;
}

void jwm::MenuMac::addItem(JNIEnv* env, MenuItemMac* item) {
    NSLog(@"MenuMac - addItem");

    [fNSMenu addItem:item->fNSMenuItem];
}


void jwm::MenuMac::setSubmenu(JNIEnv* env, MenuMac* submenu, MenuItemMac* forItem) {
    NSLog(@"MenuMac - setSubmenu");

    [fNSMenu setSubmenu:submenu->fNSMenu forItem:forItem->fNSMenuItem];
}

/*
 * Class:     io_github_humbleui_jwm_MenuMac
 * Method:    _nAddItem
 * Signature: (Lio/github/humbleui/jwm/MenuItemMac;)V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuMac__1nAddItem
        (JNIEnv* env, jobject obj, jobject itemObj) {
    jwm::MenuMac* instance = reinterpret_cast<jwm::MenuMac*>(jwm::classes::Native::fromJava(env, obj));
    jwm::MenuItemMac* item = reinterpret_cast<jwm::MenuItemMac*>(jwm::classes::Native::fromJava(env, itemObj));
    instance->addItem(env, item);
}

/*
 * Class:     io_github_humbleui_jwm_MenuMac
 * Method:    _nSetSubmenu
 * Signature: (Lio/github/humbleui/jwm/MenuMac;Lio/github/humbleui/jwm/MenuItemMac;)V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuMac__1nSetSubmenu
        (JNIEnv* env, jobject obj, jobject subMenuObj, jobject itemObj) {
    jwm::MenuMac* instance = reinterpret_cast<jwm::MenuMac*>(jwm::classes::Native::fromJava(env, obj));
    jwm::MenuMac* submenu = reinterpret_cast<jwm::MenuMac*>(jwm::classes::Native::fromJava(env, subMenuObj));
    jwm::MenuItemMac* item = reinterpret_cast<jwm::MenuItemMac*>(jwm::classes::Native::fromJava(env, itemObj));
    instance->setSubmenu(env, submenu, item);
}

/*
 * Class:     io_github_humbleui_jwm_MenuMac
 * Method:    _nMake
 * Signature: ()J
 */
extern "C" JNIEXPORT jlong JNICALL Java_io_github_humbleui_jwm_MenuMac__1nMake
        (JNIEnv* env, jclass) {
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
 * Signature: (Lio/github/humbleui/jwm/MenuMac;)V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuMac__1nSetApplicationMenu
        (JNIEnv* env, jclass, jobject obj) {
    NSLog(@"MenuMac._nSetApplicationMenu");

    jwm::MenuMac* instance = reinterpret_cast<jwm::MenuMac*>(jwm::classes::Native::fromJava(env, obj));
    [NSApp setMainMenu:instance->fNSMenu];
}
