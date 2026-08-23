{pkgs}:
# --- Launcher Script ---
pkgs.writeShellScriptBin "rofi-launcher" ''
  if pgrep -x "rofi" > /dev/null; then
    pkill -x rofi
    exit 0
  fi
  rofi -show drun
''
