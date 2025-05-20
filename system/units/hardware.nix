### CONTAINS HARDWARE AND RELATED UTILITIES
{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    pulseaudio
    alsa-utils
    brightnessctl
  ];

  services = {
    blueman.enable = true;

    pulseaudio.enable = false;

    libinput.enable = true;

    fstrim.enable = true;

    gvfs.enable = true;

    ipp-usb.enable = true;

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
}
