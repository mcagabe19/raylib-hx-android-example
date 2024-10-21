#!/bin/bash

# Function to build for a specific architecture
build_arch()
{
    local arch="$1"
    local bin_dir="bin/$arch"
    local jni_libs_dir="project/app/src/main/jniLibs/$2"
    local lib_file="$3"

    haxe build.hxml -D $arch -D ANDROID_NDK_DIR=$ANDROID_NDK_DIR -cpp "$bin_dir"
    mkdir -p "$jni_libs_dir"
    cp -rf "$bin_dir/$lib_file" "$jni_libs_dir/libMain.so"
}

# Search for the Android NDK
if [ -z "$ANDROID_NDK_ROOT" ]; then
    echo "ANDROID_NDK_ROOT is not set, searching for NDK..."
    if [ -d "$HOME/Android/Sdk/ndk" ]; then
        NDK_PATH=$(find "$HOME/Android/Sdk/ndk" -maxdepth 1 -type d | sort | tail -n 1)
    elif [ -d "/usr/local/android-ndk" ]; then
        NDK_PATH="/usr/local/android-ndk"
    else
        echo "Could not find the Android NDK automatically. Please set ANDROID_NDK_ROOT."
        exit 1
    fi
else
    NDK_PATH="$ANDROID_NDK_ROOT"
fi

echo "Using Android NDK at $NDK_PATH"
export ANDROID_NDK_DIR="$NDK_PATH"

# Parse arguments for architectures
ARCHS=("$@")
if [ ${#ARCHS[@]} -eq 0 ]; then
    ARCHS=("arm64" "armv7" "x86" "x86_64")
fi

# Build for selected architectures
for ARCH in "${ARCHS[@]}"; do
    case "$ARCH" in
        arm64)
            build_arch "HXCPP_ARM64" "arm64-v8a" "libMain-64.so"
            ;;
        armv7)
            build_arch "HXCPP_ARMV7" "armeabi-v7a" "libMain-v7.so"
            ;;
        x86)
            build_arch "HXCPP_X86" "x86" "libMain-x86.so"
            ;;
        x86_64)
            build_arch "HXCPP_X86_64" "x86_64" "libMain-x86_64.so"
            ;;
        *)
            echo "Unknown architecture: $ARCH"
            ;;
    esac
done

# Create the assets directory
mkdir -p project/app/src/main/assets
cp -rf resources project/app/src/main/assets

# Navigate to the project directory and build with Gradle
cd project
chmod +x ./gradlew
./gradlew build
