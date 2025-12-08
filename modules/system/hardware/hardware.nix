# Base hardware configuration (audio, bluetooth, input, etc.)
{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.base;
in {
  options.system.hardware.base = {
    enable = mkEnableOption "Enable base hardware configuration (audio, bluetooth, input)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alsa-utils
      pulseaudio

      brightnessctl

      unstable.lact
      nvtopPackages.full
    ];

    systemd = {
      packages = with pkgs; [unstable.lact];
      services.lactd.wantedBy = ["multi-user.target"];
    };

    services = {
      blueman.enable = true;
      pulseaudio.enable = false;
      libinput.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
      ipp-usb.enable = true;
      fwupd.enable = true;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
      hardware.bolt = {
        enable = true;
        package = pkgs.bolt;
      };
    };

    hardware = {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
