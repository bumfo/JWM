#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuItemMac.hh"

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

/*
 * Class:     io_github_humbleui_jwm_MenuItemMac
 * Method:    _nMake
 * Signature: ()J
 */
extern "C" JNIEXPORT jlong JNICALL Java_io_github_humbleui_jwm_MenuItemMac__1nMake
        (JNIEnv * env, jclass) {
    NSLog(@"MenuItemMac._nMake");

    std::unique_ptr<jwm::MenuItemMac> instance(new jwm::MenuItemMac(env));
    if (instance->init()) {
        return reinterpret_cast<jlong>(instance.release());
    } else {
        return 0;
    }
}