#!/bin/bash
set -e
pushd /etc/nixos/
alejandra . &>/dev/null
cp flake.lock flake.lock.bak
git diff -U0 flake.lock
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch &> nixos-switch.log || (
    cat nixos-switch.log | grep --color error && false
)
gen=$(nixos-rebuild list-generations | grep current | sed 's/ .*//')
patch_file="patch/${gen}.patch"
mkdir -p patch
git diff > "$patch_file"
echo "Patch stored in '$patch_file'."
git commit -am "$gen"
popd && true
