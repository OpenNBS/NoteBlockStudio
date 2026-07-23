#!/bin/sh
set -eu

cd "$(dirname "$0")"
cc gmx11windowstate.c -o libgmx11windowstate.so -std=c11 -O2 -shared -fPIC $(pkg-config --cflags --libs x11)
