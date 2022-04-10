#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuItemMac.hh"
#include <StringUTF16.hh>

jwm::MenuItemMac::~MenuItemMac() {
    NSLog(@"MenuItemMac - release");
    [fNSMenuItem release];
}

bool jwm::MenuItemMac::init() {
    NSLog(@"MenuItemMac - init");

    fNSMenuItem = [[NSMenuItem alloc] initWithTitle:@"MenuItem" action:nil keyEquivalent:@""];

    // NSMenu* menu = [[NSMenu alloc] initWithTitle:@"Apple"];
    // [[NSApp mainMenu] setSubmenu:menu forItem:fNSMenuItem];
    //
    // NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"Quit Custom" action:@selector(terminate:) keyEquivalent:@"q"];
    // [menu addItem:item];
    // [item release];
    // [menu release];

    return true;
}

void jwm::MenuItemMac::setTitle(std::string titleStr) {
    NSString* title = [NSString stringWithUTF8String:titleStr.c_str()];

    if (titleStr == "Quit") {
        [fNSMenuItem setAction:@selector(terminate:)];
        [fNSMenuItem setKeyEquivalent:@"q"];
    }

    [fNSMenuItem setTitle:title];
}

/*
 * Class:     io_github_humbleui_jwm_MenuItemMac
 * Method:    _nSetTitle
 * Signature: (Ljava/lang/String;)V
 */
extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_MenuItemMac__1nSetTitle
        (JNIEnv* env, jobject obj, jstring titleStr) {
    jwm::MenuItemMac* instance = reinterpret_cast<jwm::MenuItemMac*>(jwm::classes::Native::fromJava(env, obj));
    jsize len = env->GetStringLength(titleStr);
    const jchar* chars = env->GetStringCritical(titleStr, nullptr);
    NSString* title = [[NSString alloc] initWithCharacters:chars length:len];
    env->ReleaseStringCritical(titleStr, chars);
    [instance->fNSMenuItem setTitle:title];
    [title release];

    // jwm::StringUTF16 title = jwm::StringUTF16::makeFromJString(env, titleStr);
    // instance->setTitle(title.toAscii());
}

/*
 * Class:     io_github_humbleui_jwm_MenuItemMac
 * Method:    _nMake
 * Signature: ()J
 */
extern "C" JNIEXPORT jlong JNICALL Java_io_github_humbleui_jwm_MenuItemMac__1nMake
        (JNIEnv* env, jclass) {
    NSLog(@"MenuItemMac._nMake");

    std::unique_ptr<jwm::MenuItemMac> instance(new jwm::MenuItemMac(env));
    if (instance->init()) {
        return reinterpret_cast<jlong>(instance.release());
    } else {
        return 0;
    }
}