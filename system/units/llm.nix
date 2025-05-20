{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ollama
    # open-webui
  ];

  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    # open-webui = {
    #   enable = true;
    #   openFirewall = true;
    #   environment = {
    #     ANONYMIZED_TELEMETRY = "False";
    #     DO_NOT_TRACK = "True";
    #     SCARF_NO_ANALYTICS = "True";
    #   };
    # };
  };
}
