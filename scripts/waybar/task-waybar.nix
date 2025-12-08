{pkgs}:
pkgs.writeShellScriptBin "task-waybar" ''
  sleep 0.1
  ${lib.getExe pkgs.swaynotificationcenter} -t &
''
