#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuMac.hh"
#include "MenuItemMac.hh"
#include <StringUTF16.hh>

jwm::MenuMac::~MenuMac() {
    NSLog(@"MenuMac - release");
    [fNSMenu release];
}

bool jwm::MenuMac::init() {
    NSLog(@"MenuMac - init");

    fNSMenu = [[NSMenu alloc] initWithTitle:@"Menu"];

    return true;
}

void jwm::MenuMac::setTitle(NSString* title) {
    [fNSMenu setTitle:title];

    if ([title isEqualToString:@"Apple"]) {

    } else if ([title isEqualToString:@"View"]) {

    } else if ([title isEqualToString:@"Window"]) {
        NSApp.windowsMenu = fNSMenu;
    } else if ([title isEqualToString:@"Service"]) {
        NSApp.servicesMenu = fNSMenu;
    } else if ([title isEqualToString:@"Help"]) {
        NSApp.helpMenu = fNSMenu;
    }
}

void jwm::MenuMac::setTitle(std::string titleStr) {
    NSString* title = [[NSString alloc] initWithUTF8String:titleStr.c_str()];
    setTitle(title);
    [title release];
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
 * Method:    _nSetTitle
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuMac__1nSetTitle
        (JNIEnv* env, jobject obj, jstring titleStr) {
    jwm::MenuMac* instance = reinterpret_cast<jwm::MenuMac*>(jwm::classes::Native::fromJava(env, obj));
    jsize len = env->GetStringLength(titleStr);
    const jchar* chars = env->GetStringCritical(titleStr, nullptr);
    NSString* title = [[NSString alloc] initWithCharacters:chars length:len];
    env->ReleaseStringCritical(titleStr, chars);
    instance->setTitle(title);
    [title release];

    // jwm::StringUTF16 title = jwm::StringUTF16::makeFromJString(env, titleStr);
    // instance->setTitle(title.toAscii());
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
