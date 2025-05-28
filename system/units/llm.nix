{pkgs, ...}: {
  services = {
    ollama = {
      enable = true;
      package = pkgs.stable.ollama;
      acceleration = "cuda";
    };

    open-webui = {
      enable = true;
      package = pkgs.stable.open-webui;
      openFirewall = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };
  };
}
