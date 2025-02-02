{
  lib,
  pkgs,
  ...
}: let
  wrap = {appName}:
    pkgs.symlinkJoin {
      name = appName;
      paths = [pkgs.${appName}];
      buildInputs = [pkgs.makeWrapper];
      postBuild = lib.strings.concatStrings [
        "wrapProgram $out/bin/"
        appName
        " --add-flags \"--ozone-platform-hint=auto\""
        " --add-flags \"--enable-webrtc-pipewire-capturer\""
        " --add-flags \"--enable-features=WaylandWindowDecorations\""
        " --add-flags \"--enable-wayland-ime\""
      ];
    };

  obsidian = wrap {appName = "obsidian";};
  bruno = wrap {appName = "bruno";};
in {
  environment.systemPackages = [
    bruno
    obsidian
  ];
}
