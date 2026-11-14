#!/bin/sh
set -eu

build_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$build_directory"

# The launcher has no global state or initialization and calls only Win32 APIs,
# so it does not need a C runtime or a DLL entry point.
i686-w64-mingw32-gcc \
    windows_update_launcher.c \
    -o windows_update_launcher.dll \
    -std=c11 -Os -Wall -Wextra -Werror \
    -shared -nostdlib -s \
    -lkernel32 -lshell32 -luser32 \
    -Wl,--no-insert-timestamp,--entry,0

x86_64-w64-mingw32-gcc \
    windows_update_launcher.c \
    -o windows_update_launcher_x64.dll \
    -std=c11 -Os -Wall -Wextra -Werror \
    -shared -nostdlib -s \
    -lkernel32 -lshell32 -luser32 \
    -Wl,--no-insert-timestamp,--entry,0
