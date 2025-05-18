#!/bin/bash
set -e
pushd /etc/nixos/
alejandra . &>/dev/null
cp flake.lock flake.lock.bak
git diff -U0 flake.lock
echo "NixOS Rebuilding..."
sudo nixos-rebuild test &>nixos-switch.log || (
 cat nixos-switch.log | grep --color error && false)
popd && true
