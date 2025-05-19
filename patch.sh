#!/bin/bash
if [[ -d "patch" && "$(ls -A patch)" ]]; then
    git apply patch/* --allow-empty
    echo "Patch Applied"

    read -p "Do you want to delete all patches in the 'patch' directory? (y/N): " confirmation

    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        rm -rf ./patch/*
        echo "All patches in 'patch' have been deleted."
    else
        echo "No patches were deleted."
    fi
else
    echo "The 'patch' directory is empty or it does not exists"
fi
