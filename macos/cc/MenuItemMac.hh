#pragma once

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "MenuItem.hh"

namespace jwm {
    class MenuItemMac: MenuItem {
    public:
        // MenuItemMac(JNIEnv* env): MenuItem(env) {}
        MenuItemMac(JNIEnv* env) {}

        ~MenuItemMac() override;

        bool init();

        void setTitle(NSString* title);
        void setTitle(std::string title);

        NSMenuItem* fNSMenuItem = nullptr;
    };
}
