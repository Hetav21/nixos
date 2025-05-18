#!/usr/bin/env bash

# Define variables for directories and files
USER_HOME=$(eval echo ~$SUDO_USER)
FLAKE_DIR="$USER_HOME/nix"

# Run nixos-generate-config command
sudo nixos-generate-config --show-hardware-config > "$FLAKE_DIR/hosts/default/hardware-configuration.nix" || { echo "Failed to generate hardware configuration"; exit 1; }

# Navigate to home directory
cd "$USER_HOME" || { echo "Failed to cd to home directory"; exit 1; }

# Navigate back to ~/nix
cd "$FLAKE_DIR" || { echo "Failed to cd to $FLAKE_DIR"; exit 1; }

# Rebuild NixOS configuration
sudo nixos-rebuild switch --flake .#default || { echo "Failed to rebuild NixOS configuration"; exit 1; }

# Post Install
sudo virsh net-autostart default

echo "Script completed successfully."
