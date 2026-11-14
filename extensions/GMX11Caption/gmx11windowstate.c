#include <stdint.h>
#include <X11/Xlib.h>

#define GMX11_EXPORT extern __attribute__((visibility("default")))

GMX11_EXPORT double gmx11_unmaximize(void *window) {
    if (window == NULL) return 0.0;

    Display *display = XOpenDisplay(NULL);
    if (display == NULL) return 0.0;

    Atom state = XInternAtom(display, "_NET_WM_STATE", False);
    Atom maximized_horz = XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_HORZ", False);
    Atom maximized_vert = XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_VERT", False);

    XClientMessageEvent event = {0};
    event.type = ClientMessage;
    event.window = (Window)(uintptr_t)window;
    event.message_type = state;
    event.format = 32;
    event.data.l[0] = 0; /* _NET_WM_STATE_REMOVE */
    event.data.l[1] = maximized_horz;
    event.data.l[2] = maximized_vert;
    event.data.l[3] = 1; /* Request originated from a normal application. */

    Status sent = XSendEvent(
        display,
        DefaultRootWindow(display),
        False,
        SubstructureRedirectMask | SubstructureNotifyMask,
        (XEvent *)&event
    );

    XFlush(display);
    XCloseDisplay(display);
    return sent != 0 ? 1.0 : 0.0;
}
