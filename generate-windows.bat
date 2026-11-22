@echo off
setlocal
pushd "%~dp0"
call ClangSharpPInvokeGenerator @generate-windows.rsp
set "RESULT=%ERRORLEVEL%"
if not "%RESULT%"=="0" echo ClangSharpPInvokeGenerator failed with exit code %RESULT%.
popd
exit /b %RESULT%
