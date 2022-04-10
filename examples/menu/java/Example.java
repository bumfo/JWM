package io.github.humbleui.jwm.examples;

import io.github.humbleui.jwm.App;
import io.github.humbleui.jwm.Event;
import io.github.humbleui.jwm.EventWindowClose;
import io.github.humbleui.jwm.EventWindowCloseRequest;
import io.github.humbleui.jwm.Menu;
import io.github.humbleui.jwm.MenuItemMac;
import io.github.humbleui.jwm.MenuMac;
import io.github.humbleui.jwm.Window;
import io.github.humbleui.jwm.skija.EventFrameSkija;
import io.github.humbleui.jwm.skija.LayerGLSkija;
import io.github.humbleui.skija.Canvas;
import io.github.humbleui.skija.Paint;
import io.github.humbleui.skija.Surface;
import io.github.humbleui.types.Rect;

import java.util.function.Consumer;

public class Example implements Consumer<Event> {
    public Window window;

    public Example() {
        window = App.makeWindow();
        window.setEventListener(this);
        window.setTitle("Menu Example");
        window.setLayer(new LayerGLSkija());

        var screen = App.getPrimaryScreen();
        var scale = screen.getScale();
        var bounds = screen.getWorkArea();

        window.setWindowSize((int) (300 * scale), (int) (600 * scale));
        window.setWindowPosition((int) (300 * scale), (int) (200 * scale));
        window.setVisible(true);

        Menu menu = Menu.make();
        if (menu instanceof MenuMac menubar) {
            MenuMac.setApplicationMenu(menubar);
            menubar
                .addItem(new MenuItemMac().setTitle("Apple").setSubmenu(new MenuMac()
                    .addItem(new MenuItemMac().setTitle("Apple.1"))
                    .addItem(new MenuItemMac().setTitle("Quit"))))
                .addItem(new MenuItemMac().setTitle("View").setSubmenu(new MenuMac()
                    .addItem(new MenuItemMac().setTitle("View.1"))))
                .addItem(new MenuItemMac().setTitle("Service").setSubmenu(new MenuMac()
                    .addItem(new MenuItemMac().setTitle("Service.1"))))
                .addItem(new MenuItemMac().setTitle("Window").setSubmenu(new MenuMac()
                    .addItem(new MenuItemMac().setTitle("Window.1"))))
                .addItem(new MenuItemMac().setTitle("Help").setSubmenu(new MenuMac()
                    .addItem(new MenuItemMac().setTitle("Help.1").setSubmenu(new MenuMac()
                        .addItem(new MenuItemMac().setTitle("Help.1.1"))))));

            // menubar
            //     .addItem(new MenuItemMac().setTitle("App").setSubmenu(new MenuMac()
            //         .addItem(new MenuItemMac().setTitle("About"))
            //         .addItem(new MenuItemMac().setTitle("Quit"))))
            //     .addItem(new MenuItemMac().setTitle("View").setSubmenu(new MenuMac()
            //         .addItem(new MenuItemMac().setTitle("Enter Full Screen"))));
        }
    }

    public void paint(Canvas canvas, int width, int height) {
        float scale = window.getScreen().getScale();
        canvas.clear(0xFF264653);
        try (var paint = new Paint()) {
            paint.setColor(0xFFe76f51);

            canvas.drawRect(Rect.makeXYWH(10 * scale, 10 * scale, 10 * scale, 10 * scale), paint);
            canvas.drawRect(Rect.makeXYWH(width - 20 * scale, 10 * scale, 10 * scale, 10 * scale), paint);
            canvas.drawRect(Rect.makeXYWH(10 * scale, height - 20 * scale, 10 * scale, 10 * scale), paint);
            canvas.drawRect(Rect.makeXYWH(width - 20 * scale, height - 20 * scale, 10 * scale, 10 * scale), paint);
            canvas.drawRect(Rect.makeXYWH(width / 2 - 5 * scale, height / 2 - 5 * scale, 10 * scale, 10 * scale), paint);
        }
    }

    @Override
    public void accept(Event e) {
        if (e instanceof EventWindowClose) {
            if (App._windows.size() == 0) {
                App.terminate();
            }
            return;
        } else if (e instanceof EventFrameSkija ee) {
            Surface s = ee.getSurface();
            paint(s.getCanvas(), s.getWidth(), s.getHeight());
        } else if (e instanceof EventWindowCloseRequest) {
            window.close();
        }
    }

    public static void main(String[] args) {
        App.start(() -> {
            new Example();
            System.gc();
        });
    }
}