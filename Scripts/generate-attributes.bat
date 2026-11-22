@echo off
setlocal
pushd "%~dp0.." || exit /b 1
call ClangSharpPInvokeGenerator @Scripts\generate-attributes.rsp
set "RESULT=%ERRORLEVEL%"
if not "%RESULT%"=="0" echo ClangSharpPInvokeGenerator failed with exit code %RESULT%.
popd
exit /b %RESULT%
