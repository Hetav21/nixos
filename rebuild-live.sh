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
cp ~/.config/zed/settings.json ./dotfiles/.config/zed/settings.json
gen=$(nixos-rebuild list-generations | grep True | sed 's/ .*//')
git commit -am "$gen"
mkdir -p patch
git format-patch -1 HEAD
mv *.patch patch/
echo "Patch Created."
popd && true
