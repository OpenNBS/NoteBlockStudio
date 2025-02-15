cd "${0%/*}"

if [ `uname` = "Darwin" ]; then
  clang++ "libzoom.cpp" -o "libzoom.dylib" -I. -std=c++17 -shared -ObjC++ -framework AppKit -mmacos-version-min=10.13 -arch arm64 -arch x86_64 -fPIC;
elif [ $(uname) = "Linux" ]; then
  g++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared -static-libgcc -static-libstdc++ `pkg-config --cflags --libs x11` -fPIC;
elif [ $(uname) = "FreeBSD" ]; then
  clang++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared `pkg-config --cflags --libs x11`;
elif [ $(uname) = "DragonFly" ]; then
  g++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared -static-libgcc -static-libstdc++ `pkg-config --cflags --libs x11` -fPIC;
elif [ $(uname) = "NetBSD" ]; then
  g++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared -static-libgcc -static-libstdc++ `pkg-config --cflags --libs x11` -fPIC;
elif [ $(uname) = "OpenBSD" ]; then
  clang++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared `pkg-config --cflags --libs x11`;
elif [ $(uname) = "SunOS" ]; then
  export PKG_CONFIG_PATH=/usr/lib/64/pkgconfig && g++ "libzoom.cpp" -o "libzoom.so" -std=c++17 -shared -static-libgcc `pkg-config --cflags --libs x11` -fPIC;
else
  g++ "libzoom.cpp" -o "libzoom.dll" -std=c++17 -shared -static-libgcc -static-libstdc++ -static -fPIC;
fi
