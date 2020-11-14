#!/bin/bash

NDK_ROOT=/Users/chris/development/sdk/ndk/21.0.6113669

#cpu类型
CPU=arm-linux-androideabi

TOOLCHAIN=$NDK_ROOT/toolchains/$CPU-4.9/prebuilt/darwin-x86_64
#Android版本指定
ANDROID_API=21
#编译成果输出目录
PREFIX=/Users/chris/temp/compile_lib/ffmpeg_rtmp

echo 'rtmp路径:'$PREFIX
echo 'ndk路径:'$NDK_ROOT

#rtmp路径 链接已经编译好的rtmp库
RTMP=/Users/chris/temp/compile_lib/rtmp

./configure \
--prefix=$PREFIX \
--enable-small \
--disable-programs \
--disable-avdevice \
--disable-encoders \
--disable-muxers \
--disable-filters \
--enable-librtmp \
--enable-cross-compile \
--cross-prefix=$TOOLCHAIN/bin/$CPU- \
--disable-shared \
--enable-static \
--sysroot=$NDK_ROOT/platforms/android-$ANDROID_API/arch-arm \
--extra-cflags="-isysroot $NDK_ROOT/sysroot -isystem $NDK_ROOT/sysroot/usr/include/arm-linux-androideabi -I$NDK_ROOT/sysroot/usr/include -I/usr/local/include -I/usr/local/Cellar/gcc/9.2.0/lib/gcc/9/gcc/x86_64-apple-darwin18/9.2.0/include -D__ANDROID_API__=$ANDROID_API -U_FILE_OFFSET_BITS -DANDROID -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -Wa,--noexecstack -Wformat -Werror=format-security  -O0 -fPIC -I$RTMP/include" \
--extra-ldflags="-L$RTMP/lib" \
--extra-libs="-lrtmp" \
--arch=arm \
--target-os=android

make clean
make -j6
make install
