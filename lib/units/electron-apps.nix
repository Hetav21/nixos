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
        " --add-flags \"--enable-features=UseOzonePlatform\""
        " --add-flags \"--ozone-platform-hint=wayland\""
        " --add-flags \"--enable-webrtc-pipewire-capturer\""
        " --add-flags \"--enable-features=WaylandWindowDecorations\""
        " --add-flags \"--enable-wayland-ime\""
        " --add-flags \"--disable-gpu\""
      ];
    };

  bruno = wrap {appName = "bruno";};
  obsidian = wrap {appName = "obsidian";};
in {
  environment.systemPackages = [
    bruno
    obsidian
  ];
}
