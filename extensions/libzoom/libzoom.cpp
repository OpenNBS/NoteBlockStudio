/*

 MIT License

 Copyright © 2023 Samuel Venable

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

*/

#include <cstdint>
#if defined(_WIN32)
#include <windows.h>
#define EXPORTED_FUNCTION extern "C" __declspec(dllexport)
#else
#define EXPORTED_FUNCTION extern "C" __attribute__((visibility("default")))
#if (defined(__APPLE__) && defined(__MACH__))
#include <AppKit/AppKit.h>
#include <libproc.h>
#else
#include <X11/Xlib.h>
#endif
#endif

EXPORTED_FUNCTION void window_zoom(void *window) {
  #if defined(_WIN32)
  ShowWindow((HWND)window, SW_MAXIMIZE);
  #elif (defined(__APPLE__) && defined(__MACH__))
  [(NSWindow *)window zoom:nil];
  #else
  Display *display = XOpenDisplay(nullptr);
  XClientMessageEvent ev;
  Atom state, h, v;
  state = XInternAtom(display, "_NET_WM_STATE", false);
  if (state == None) return;
  h = XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_HORZ", false);
  v = XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_VERT", false);
  ev.type = ClientMessage;
  ev.window = (Window)(std::uintptr_t)window;
  ev.message_type = state;
  ev.format = 32;
  ev.data.l[0] = 1;
  ev.data.l[1] = h;
  ev.data.l[2] = v;
  XSendEvent(display, RootWindow(display, 0), false, SubstructureRedirectMask | SubstructureNotifyMask, (XEvent *)&ev);
  XCloseDisplay(display);
  #endif
}

EXPORTED_FUNCTION void window_focus(void *window) {
  #if defined(_WIN32)
  SetWindowPos((HWND)window, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
  SetWindowPos((HWND)window, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
  #elif (defined(__APPLE__) && defined(__MACH__))
  CGWindowID wid = [(NSWindow *)window windowNumber];
  const CGWindowLevel kScreensaverWindowLevel = CGWindowLevelForKey(kCGScreenSaverWindowLevelKey);
  CFArrayRef windowArray = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
  CFIndex windowCount = 0;
  if ((windowCount = CFArrayGetCount(windowArray))) {
    for (CFIndex i = 0; i < windowCount; i++) {
      NSDictionary *windowInfoDictionary = (__bridge NSDictionary *)((CFDictionaryRef)CFArrayGetValueAtIndex(windowArray, i));
      NSNumber *ownerPID = (NSNumber *)(windowInfoDictionary[(id)kCGWindowOwnerPID]);
      NSNumber *level = (NSNumber *)(windowInfoDictionary[(id)kCGWindowLayer]);
      if (level.integerValue < kScreensaverWindowLevel) {
        NSNumber *windowID = windowInfoDictionary[(id)kCGWindowNumber];
        if (wid == windowID.integerValue) {
          CFIndex appCount = [[[NSWorkspace sharedWorkspace] runningApplications] count];
          for (CFIndex j = 0; j < appCount; j++) {
            if (ownerPID.integerValue == [[[[NSWorkspace sharedWorkspace] runningApplications] objectAtIndex:j] processIdentifier]) {
              NSRunningApplication *appWithPID = [[[NSWorkspace sharedWorkspace] runningApplications] objectAtIndex:j];
              if (@available(macOS 14.0, *)) {
                [[NSApplication sharedApplication] yieldActivationToApplication:appWithPID];
                [appWithPID activateWithOptions:NSApplicationActivateAllWindows];
              } else {
                #pragma GCC diagnostic push
                #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [appWithPID activateWithOptions:NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps];
                #pragma clang diagnostic pop
                #pragma GCC diagnostic pop
              }
              char buf[PROC_PIDPATHINFO_MAXSIZE];
              proc_pidpath(ownerPID.integerValue, buf, sizeof(buf));
              NSString *buffer = [NSString stringWithUTF8String:buf];
              unsigned long location = [buffer rangeOfString:@".app/Contents/MacOS/" options:NSBackwardsSearch].location;
              NSString *path = (location != NSNotFound) ? [buffer substringWithRange:NSMakeRange(0, location)] : buffer;
              NSString *app = [@" of application \\\"" stringByAppendingString:[path lastPathComponent]];
              NSString *index = [@"set index of window id " stringByAppendingString:[windowID stringValue]];
              NSString *execScript = [[index stringByAppendingString:app] stringByAppendingString:@"\\\" to 1"];
              char *pointer = nullptr;
              size_t buffer_size = 0;
              NSAppleScript *script = [[NSAppleScript alloc] initWithSource:execScript];
              NSDictionary *errInfo = nil;
              [script executeAndReturnError:&errInfo];
              [script release];
              break;
            }
          }
        }
      }
    }
  }
  #else
  Display *display = XOpenDisplay(nullptr);
  XEvent event;
  event.xclient.type = ClientMessage;
  event.xclient.serial = 0;
  event.xclient.send_event = true;
  event.xclient.message_type = XInternAtom(display, "_NET_ACTIVE_WINDOW", false);
  event.xclient.window = (Window)(std::uintptr_t)window;
  event.xclient.format = 32;
  XSendEvent(display, DefaultRootWindow(display), false, SubstructureRedirectMask | SubstructureNotifyMask, &event);
  XMapRaised(display, (Window)(std::uintptr_t)window);
  XMapWindow(display, (Window)(std::uintptr_t)window);
  XCloseDisplay(display);
  #endif
}

EXPORTED_FUNCTION void window_hide(void *window) {
  #if defined(_WIN32)
  SetWindowLong((HWND)window, GWL_STYLE, WS_POPUP);
  MoveWindow((HWND)window, 0, 0, 1, 1, false);
  SetWindowLong((HWND)window, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TOOLWINDOW);
  SetLayeredWindowAttributes((HWND)window, RGB(0, 0, 0), 0, LWA_ALPHA);
  #elif (defined(__APPLE__) && defined(__MACH__))
  [[NSApplication sharedApplication] setActivationPolicy:(NSApplicationActivationPolicy)1];
  if (@available(macOS 14.0, *)) {
    [[NSApplication sharedApplication] yieldActivationToApplication:[NSRunningApplication currentApplication]];
    [[NSApplication sharedApplication] activate];
  } else {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  }
  [(NSWindow *)window setStyleMask:NSWindowStyleMaskBorderless];
  [(NSWindow *)window setFrame:NSMakeRect(0, 0, 1, 1) display:YES];
  [(NSWindow *)window setAlphaValue:0];
  #else
  Display *display = XOpenDisplay(nullptr);
  XUnmapWindow(display, (Window)(std::uintptr_t)window);
  XCloseDisplay(display);
  #endif
}
