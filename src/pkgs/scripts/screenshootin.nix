{pkgs}:
# --- Screenshot Helper Script ---
pkgs.writeShellScriptBin "screenshootin" ''
  grim -g "$(slurp)" - | swappy -f -
''
