{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.llm.open-webui";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Open WebUI Service ---
    services.open-webui = {
      enable = true;
      package = pkgs.open-webui;
      openFirewall = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };
  };
}
