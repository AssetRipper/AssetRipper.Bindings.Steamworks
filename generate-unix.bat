@echo off
setlocal
pushd "%~dp0" || exit /b 1

set "INCLUDE=%CD%\Cache\linux-sysroot\usr\include"
if not exist "%INCLUDE%\string.h" (
    echo Linux headers not found. Run download-linux-headers.ps1 first.
    popd
    exit /b 1
)
if not exist "%INCLUDE%\x86_64-linux-gnu\bits\libc-header-start.h" (
    echo Linux architecture-specific headers not found in "%INCLUDE%".
    popd
    exit /b 1
)

set "RESOURCE_DIR="
for /f "delims=" %%i in ('clang -print-resource-dir') do set "RESOURCE_DIR=%%i"
if not exist "%RESOURCE_DIR%\include\stddef.h" (
    echo Clang builtin headers not found. Install Clang and add it to PATH.
    popd
    exit /b 1
)

call ClangSharpPInvokeGenerator @generate-unix.rsp --resource-directory "%RESOURCE_DIR%" --additional -isystem --additional "%INCLUDE%" --additional -isystem --additional "%INCLUDE%\x86_64-linux-gnu" %*
set "RESULT=%ERRORLEVEL%"
if not "%RESULT%"=="0" echo ClangSharpPInvokeGenerator failed with exit code %RESULT%.
popd
exit /b %RESULT%
