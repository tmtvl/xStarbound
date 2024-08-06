@echo off

cd /d %~dp0
cd ..\..

cd build
IF %ERRORLEVEL% NEQ 0 (
    echo "[xStarbound::Build] Build directory not found! Please make a directory called 'build'."
    exit /b %ERRORLEVEL%
)

"C:\Program Files (x86)\CMake\bin\cmake.exe" --build . --config %1

:selectDirectory
echo "[xStarbound::Build] Waiting for directory selection."
:: Borrowed from this batch script on TenForums.com: https://www.tenforums.com/general-support/179377-bat-script-select-folder-update-path-bat-file.html
call :@ "Either select your Starbound install directory and click OK to install, or click Cancel to skip installation." SourceFolder
:@
set "@="(new-object -COM 'Shell.Application').BrowseForFolder(0,'%1',0x200,0).self.path""
for /f "usebackq delims=" %%# in (`PowerShell %@%`) do set "sbInstall=%%#"
:: ----------

If "%sbInstall%"=="" (exit)
if exist "%sbInstall%\assets\packed.pak" (
    echo "[xStarbound::Build] Installing xClient into chosen Starbound directory."
    "C:\Program Files (x86)\CMake\bin\cmake.exe" --install . --prefix %sbInstall%
) else (
    echo "[xStarbound::Build] Not a valid Starbound directory!"
    goto selectDirectory
)