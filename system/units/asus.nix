{...}: {
  services = {
    supergfxd.enable = true;

    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  programs = {
    rog-control-center = {
      enable = true;
      autoStart = true;
    };
  };
}
