#pragma once

#include "Menu.hh"
#include "MenuItemMac.hh"

namespace jwm {
    class MenuMac: public Menu {
    public:
        MenuMac(JNIEnv* env): Menu(env) {}
        ~MenuMac() override;

        bool init();

        void addItem(JNIEnv* env, MenuItemMac* item);

        NSMenu* fNSMenu = nullptr;
    };
}