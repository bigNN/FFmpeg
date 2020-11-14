#!/bin/bash
#NDK_ROOT 变量指向ndk目录 可以编译的
NDK_ROOT=/Users/chris/development/sdk/ndk/21.0.6113669
#TOOLCHAIN 变量指向ndk中的交叉编译gcc所在的目录
TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
#指定android api版本
ANDROID_API=21

#此变量用于编译完成之后的库与头文件存放在哪个目录
PREFIX=/Users/chris/temp/compile_lib/ffmpeg

CC=$NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android$ANDROID_API-clang
CXX=$NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android$ANDROID_API-clang++

#执行configure脚本，用于生成makefile
#--prefix : 安装目录
#--enable-small : 优化大小
#--disable-programs : 不编译ffmpeg程序(命令行工具)，我们是需要获得静态(动态)库。
#--disable-avdevice : 关闭avdevice模块，此模块在android中无用
#--disable-encoders : 关闭所有编码器 (播放不需要编码)
#--disable-muxers :  关闭所有复用器(封装器)，不需要生成mp4这样的文件，所以关闭
#--disable-filters :关闭视频滤镜
#--enable-cross-compile : 开启交叉编译
#--cross-prefix: gcc的前缀 xxx/xxx/xxx-gcc 则给xxx/xxx/xxx-
#disable-shared enable-static 不写也可以，默认就是这样的。
#--sysroot:
#--extra-cflags: 会传给gcc的参数
#--arch --target-os : 必须要给
./configure \
--prefix=$PREFIX \
--enable-small \
--disable-programs \
--disable-avdevice \
--disable-encoders \
--disable-muxers \
--disable-filters \
--enable-cross-compile \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--disable-shared \
--enable-static \
--sysroot=$NDK_ROOT/platforms/android-$ANDROID_API/arch-arm \
--extra-cflags="-I$NDK_ROOT/sysroot/usr/include -I$NDK_ROOT/sysroot/usr/include/arm-linux-androideabi -I/usr/local/Cellar/gcc/9.2.0/lib/gcc/9/gcc/x86_64-apple-darwin18/9.2.0/include -D__ANDROID_API__=$ANDROID_API -U_FILE_OFFSET_BITS  -DANDROID -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -Wa,--noexecstack -Wformat -Werror=format-security  -O0 -fPIC" \
--arch=arm \
--target-os=android
#上面运行脚本生成makefile之后，使用make执行脚本
make clean
make install
