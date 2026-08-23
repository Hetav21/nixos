#!/usr/bin/env bash
set -euo pipefail

# --- Patch Application ---
if [[ -d "patch" && "$(ls -A patch)" ]]; then
  git apply patch/* --allow-empty
  echo "Patch applied successfully."

  # --- Cleanup Prompt ---
  read -rp "Do you want to delete all patches in the 'patch' directory? (y/N): " confirmation

  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    rm -rf ./patch/*
    echo "All patches in 'patch' have been deleted."
  else
    echo "No patches were deleted."
  fi
else
  echo "The 'patch' directory is empty or does not exist."
fi
