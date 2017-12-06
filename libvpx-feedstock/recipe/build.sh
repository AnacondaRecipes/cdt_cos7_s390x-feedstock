#!/bin/bash

if [[ $(uname) == MSYS* ]]; then
  if [[ ${ARCH} == 32 ]]; then
    HOST_BUILD="--host=i686-w64-mingw32 --build=i686-w64-mingw32"
  else
    HOST_BUILD="--host=x86_64-w64-mingw32 --build=x86_64-w64-mingw32"
  fi
  PREFIX=${PREFIX}/Library/mingw-w64
  JOBS=${NUMBER_OF_PROCESSORS}
elif [[ $(uname) == Darwin ]]; then
  JOBS=$(sysctl -n hw.ncpu)
  LDFLAGS="${LDFLAGS_CC}"
  HOST_BUILD="--target=x86_64-darwin13-gcc"
else
  JOBS=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
fi

./configure --prefix=${PREFIX}           \
            ${HOST_BUILD}                \
            --as=yasm                    \
            --enable-runtime-cpu-detect  \
            --enable-shared              \
            --enable-pic                 \
            --disable-install-docs       \
            --disable-install-srcs       \
            --enable-vp8                 \
            --enable-postproc            \
            --enable-vp9                 \
            --enable-vp9-highbitdepth    \
            --enable-experimental        \
            --enable-spatial-svc || exit 1

make -j${JOBS}
make install
