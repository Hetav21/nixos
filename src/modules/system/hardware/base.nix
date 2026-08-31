{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.hardware.base";
  hasGui = false;
  cliConfig = {
    # --- Hardware Management Packages ---
    environment.systemPackages = [
      pkgs.alsa-utils
      pkgs.pulseaudio
      pkgs.brightnessctl
      pkgs.nvtopPackages.full
      pkgs.unstable.lact
    ];

    # --- Systemd Services ---
    systemd = {
      packages = [pkgs.unstable.lact];
      services.lactd.wantedBy = ["multi-user.target"];
    };

    # --- System & Audio Services ---
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

    # --- Hardware Integration ---
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
