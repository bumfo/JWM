#include <jni.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "MenuMac.hh"

jwm::MenuMac::~MenuMac() {}

bool jwm::MenuMac::init() {
    NSLog(@"MenuMac - init");

    fNSMenu = [[NSMenu alloc] initWithTitle:@""];

    // {
    //     NSMenu *fNSMenu = [[NSMenu alloc] initWithTitle:@""];
        [NSApp setMainMenu:fNSMenu];

        NSMenuItem *item;
        NSMenu *menu;

        item = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        [fNSMenu addItem:item];

        menu = [[NSMenu alloc] initWithTitle:@"Apple"];
        [fNSMenu setSubmenu:menu forItem:item];
        [item release];

        item = [[NSMenuItem alloc] initWithTitle:@"Quit Custom" action:@selector(terminate:) keyEquivalent:@"q"];
        [menu addItem:item];
        [item release];

        [menu release];
    //     [fNSMenu release];
    // }
    //
    // NSMenuItem *menuBarItem = [[NSMenuItem alloc] initWithTitle:@"Help" action:NULL keyEquivalent:@""];
    // NSMenu *newMenu = [[NSMenu alloc] initWithTitle:@"Custom"];
    // [menuBarItem setSubmenu:newMenu];
    // [[NSApp mainMenu] insertItem:menuBarItem atIndex:1];

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
