@echo off

where rokit >nul 2>&1
IF not %errorlevel% == 0 (
    echo Rokit is not found
    echo Install it from: https://github.com/rojo-rbx/rokit
    goto end
)

echo Installing packages...
rokit install

echo Updating packages...
rokit update

echo Building and installing the plugin...
rojo build -p BlueprintPlugin.rbxm plugin.project.json

if not %errorlevel% == 0 (
    echo Failed to build and install the plugin
    goto end
)

echo Successfully installed!

:end
pause