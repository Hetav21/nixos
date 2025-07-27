{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio

    brightnessctl

    lact
    nvtopPackages.full
  ];

  systemd = {
    packages = with pkgs; [lact];
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
