#pragma once
#include "Menu.hh"

namespace jwm {
    class MenuMac: public Menu {
    public:
        MenuMac(JNIEnv* env): Menu(env) {}
        ~MenuMac() override;

        bool init();

        // NSMenu* fNSMenu = nullptr;
    };
}