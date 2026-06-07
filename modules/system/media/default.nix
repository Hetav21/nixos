{
  lib,
  config,
  ...
}: {
  imports = [
    ./mpv.nix
    ./pavucontrol.nix
    ./obs.nix
    ./upscayl.nix
    ./graphics.nix
    ./spotify.nix
    ./stremio.nix
  ];

  options = {
    system.media = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable media command-line players (CLI)";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI media creation, editing and playback apps";
      };
    };
  };

  config = {
    system.media.mpv.enable = lib.mkDefault config.system.media.enable;

    system.media.pavucontrol.enableGui = lib.mkDefault config.system.media.enableGui;
    system.media.obs.enableGui = lib.mkDefault config.system.media.enableGui;
    system.media.upscayl.enableGui = lib.mkDefault config.system.media.enableGui;
    system.media.graphics.enableGui = lib.mkDefault config.system.media.enableGui;
    system.media.spotify.enableGui = lib.mkDefault config.system.media.enableGui;
    system.media.stremio.enableGui = lib.mkDefault config.system.media.enableGui;
  };
}
