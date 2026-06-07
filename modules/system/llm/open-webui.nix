{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.llm.open-webui";
  hasCli = false;
  hasGui = true;
  guiConfig = {pkgs, ...}: {
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
})
args
