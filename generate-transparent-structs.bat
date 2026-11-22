@echo off
setlocal
pushd "%~dp0" || exit /b 1

call ClangSharpPInvokeGenerator @generate-transparent-structs.rsp
set "RESULT=%ERRORLEVEL%"
if not "%RESULT%"=="0" goto failed

del "AssetRipper.Bindings.Steamworks\Helpers\NativeAnnotationAttribute.cs" "AssetRipper.Bindings.Steamworks\Helpers\NativeTypeNameAttribute.cs"
if errorlevel 1 (popd & exit /b 1)
popd
exit /b 0

:failed
echo ClangSharpPInvokeGenerator failed with exit code %RESULT%.
popd
exit /b %RESULT%
