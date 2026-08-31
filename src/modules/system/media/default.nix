{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.media";
  imports = [
    ./mpv.nix
    ./pavucontrol.nix
    ./obs.nix
    ./upscayl.nix
    ./graphics.nix
    ./spotify.nix
    ./stremio.nix
  ];
  hasCli = true;
  cliDescription = "Enable media command-line players (CLI)";
  cliChildren = ["mpv"];
  hasGui = true;
  guiDescription = "Enable all GUI media creation, editing and playback apps";
  guiChildren = [
    "pavucontrol"
    "obs"
    "upscayl"
    "graphics"
    "spotify"
    "stremio"
  ];
}
