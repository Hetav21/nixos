# Base hardware configuration (audio, bluetooth, input, etc.)
{
  extraLib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.hardware.base";
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages =
      [
        pkgs.alsa-utils
        pkgs.pulseaudio
        pkgs.brightnessctl
        pkgs.nvtopPackages.full
      ]
      ++ [
        pkgs-unstable.lact
      ];

    systemd = {
      packages = [pkgs-unstable.lact];
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
})
args
