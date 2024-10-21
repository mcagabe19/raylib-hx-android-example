#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to build for a specific architecture
build_arch()
{
    local arch="$1"
    local bin_dir="bin/$arch"
    local jni_libs_dir="project/app/src/main/jniLibs/$2"
    local lib_file="$3"

    echo -e "${BLUE}Building for $arch...${NC}"
    haxe build.hxml -D $arch -D ANDROID_NDK_DIR=$ANDROID_NDK_DIR -cpp "$bin_dir"
    
    # Check if the build was successful
    if [ $? -ne 0 ]; then
        echo -e "${RED}Haxe build failed for $arch${NC}"
        exit 1
    fi

    echo -e "${GREEN}Copying output for $arch...${NC}"
    mkdir -p "$jni_libs_dir"
    cp -rf "$bin_dir/$lib_file" "$jni_libs_dir/libMain.so"
}

# Search for the Android NDK
if [ -z "$ANDROID_NDK_ROOT" ]; then
    echo -e "${YELLOW}ANDROID_NDK_ROOT is not set, searching for NDK...${NC}"
    if [ -d "$HOME/Android/Sdk/ndk" ]; then
        NDK_PATH=$(find "$HOME/Android/Sdk/ndk" -maxdepth 1 -type d | sort | tail -n 1)
    elif [ -d "/usr/local/android-ndk" ]; then
        NDK_PATH="/usr/local/android-ndk"
    else
        echo -e "${RED}Could not find the Android NDK automatically. Please set ANDROID_NDK_ROOT.${NC}"
        exit 1
    fi
else
    NDK_PATH="$ANDROID_NDK_ROOT"
fi

echo -e "${GREEN}Using Android NDK at $NDK_PATH${NC}"
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
            echo -e "${RED}Unknown architecture: $ARCH${NC}"
            ;;
    esac
done

# Create the assets directory
echo -e "${BLUE}Copying resources...${NC}"
mkdir -p project/app/src/main/assets
cp -rf resources project/app/src/main/assets

# Navigate to the project directory and build with Gradle
echo -e "${BLUE}Building the Android project with Gradle...${NC}"
cd project
chmod +x ./gradlew
./gradlew build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build successful!${NC}"
else
    echo -e "${RED}Gradle build failed.${NC}"
    exit 1
fi
