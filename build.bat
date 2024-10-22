@echo off
setlocal enabledelayedexpansion

:: Define ANSI color codes
set "RED=0C"
set "GREEN=0A"
set "YELLOW=0E"
set "BLUE=0B"
set "NC=07"

:: Enable ANSI escape sequences
for /f "delims=" %%A in ('powershell -command "[console]::OutputEncoding = [System.Text.Encoding]::UTF8"') do set "dummy=%%A"

:: Function to echo with color
:color_echo
set "color_code=%1"
shift
echo(
<nul set /p =[%color_code% %*
echo([%NC%
exit /b

call :color_echo %BLUE% Building for Windows...

:find_ndk
if "%ANDROID_NDK_ROOT%"=="" (
    call :color_echo %YELLOW% ANDROID_NDK_ROOT is not set, searching for NDK...
    set "NDK_PATH=%USERPROFILE%\AppData\Local\Android\Sdk\ndk"
    if exist "!NDK_PATH!" (
        for /d %%D in ("!NDK_PATH!\*") do (
            set "NDK_PATH=%%D"
        )
    ) else (
        set "NDK_PATH=C:\Program Files\Android\Android Studio\ndk"
        if exist "!NDK_PATH!" (
            for /d %%D in ("!NDK_PATH!\*") do (
                set "NDK_PATH=%%D"
            )
        )
    )
    if not exist "!NDK_PATH!" (
        call :color_echo %RED% Could not find the Android NDK automatically. Please set ANDROID_NDK_ROOT.
        exit /b 1
    )
) else (
    set "NDK_PATH=%ANDROID_NDK_ROOT%"
)

call :color_echo %GREEN% Using Android NDK at !NDK_PATH!

set "ANDROID_NDK_DIR=!NDK_PATH!"

:build_all
set ARCHS=%*
if "%ARCHS%"=="" (
    set ARCHS=arm64 armv7 x86 x86_64
)

for %%A in (%ARCHS%) do (
    set "ARCH=%%A"
    if /i "!ARCH!"=="arm64" (
        call :build_arch HXCPP_ARM64 arm64-v8a libMain-64.so
    ) else if /i "!ARCH!"=="armv7" (
        call :build_arch HXCPP_ARMV7 armeabi-v7a libMain-v7.so
    ) else if /i "!ARCH!"=="x86" (
        call :build_arch HXCPP_X86 x86 libMain-x86.so
    ) else if /i "!ARCH!"=="x86_64" (
        call :build_arch HXCPP_X86_64 x86_64 libMain-x86_64.so
    ) else (
        call :color_echo %RED% Unknown architecture: !ARCH!
        exit /b 1
    )
)

call :color_echo %BLUE% Copying resources...
mkdir project\app\src\main\assets 2>nul
xcopy /Y /E resources project\app\src\main\assets >nul

call :color_echo %BLUE% Building the Android project with Gradle...
cd project
call gradlew.bat build

if errorlevel 1 (
    call :color_echo %RED% Gradle build failed.
    exit /b 1
)

call :color_echo %GREEN% Build successful!
exit /b 0

:build_arch
set "arch=%1"
set "bin_dir=bin\%arch%"
set "jni_libs_dir=project\app\src\main\jniLibs\%2"
set "lib_file=%3"

call :color_echo %BLUE% Building for !arch!...

haxe build.hxml -D !arch! -D ANDROID_NDK_DIR=!ANDROID_NDK_DIR! -cpp "!bin_dir!" 
if errorlevel 1 (
    call :color_echo %RED% Haxe build failed for !arch!
    exit /b 1
)

call :color_echo %GREEN% Copying output for !arch!...
mkdir "!jni_libs_dir!" 2>nul
copy /Y "!bin_dir!\!lib_file!" "!jni_libs_dir!\libMain.so" >nul

goto :eof
