#!/bin/bash
set -e
pushd /etc/nixos/
alejandra . &>/dev/null
git diff -U0 flake.lock
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch &>nixos-switch.log || (
 cat nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"
popd && true
