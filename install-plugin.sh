#!/bin/bash

if ! command -v rokit &> /dev/null; then
    echo "Rokit is not found"
    echo "Install it from: https://github.com/rojo-rbx/rokit"
    exit 1
fi

echo "Installing packages..."
rokit install

echo "Updating packages..."
rokit update

echo "Building and installing the plugin..."
rojo build -p BlueprintPlugin.rbxm plugin.project.json

if [ $? -ne 0 ]; then
    echo "Failed to build and install the plugin"
    exit 1
fi

echo "Successfully installed!"
