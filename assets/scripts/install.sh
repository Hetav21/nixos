#!/usr/bin/env bash
set -euo pipefail

# --- Paths & Configuration ---
USER_HOME="$(eval echo "~$SUDO_USER")"
FLAKE_DIR="$USER_HOME/nix"

# --- Hardware Configuration ---
sudo nixos-generate-config --show-hardware-config > "$FLAKE_DIR/hosts/default/hardware-configuration.nix" || {
  echo "Error: Failed to generate hardware configuration" >&2
  exit 1
}

# --- System Build ---
cd "$FLAKE_DIR" || {
  echo "Error: Failed to cd to $FLAKE_DIR" >&2
  exit 1
}

sudo nixos-rebuild switch --flake .#default || {
  echo "Error: Failed to rebuild NixOS configuration" >&2
  exit 1
}

# --- Post-Install Steps ---
sudo virsh net-autostart default || true

echo "Installation completed successfully."
