{
  lib,
  pkgs,
  inputs,
  settings,
  config,
  ...
}:
with lib; let
  cfg = config.home.browser.zen;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  options.home.browser.zen = {
    enableGui = mkEnableOption "Enable GUI web browser (Zen)";
  };

  config = mkIf cfg.enableGui {
    stylix.targets.zen-browser = {
      enable = true;
      profileNames = ["${settings.username}"];
    };

    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      profiles = {"${settings.username}" = {isDefault = true;};};
      policies = {
        # find more options here: https://mozilla.github.io/policy-templates/
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Preferences = let
          locked = value: {
            "Value" = value;
            "Status" = "locked";
          };
        in {
          # Nebula Preferences
          "nebula-tab-switch-animation" = locked 4;
          "nebula-tab-loading-animation" = locked 0;

          # Zen Preferences
          "zen.view.grey-out-inactive-windows" = locked false;

          # Firefox Preferences
          "browser.tabs.warnOnClose" = locked false;
        };
        SearchEngines = {
          Default = "Unduck";
          Add = [
            {
              Name = "Unduck";
              URL = "https://unduck.link?q={searchTerms}";
              Alias = "unduck";
            }
            {
              Name = "NixOS Wiki";
              URL = "https://nixos.wiki/index.php?search={searchTerms}";
              Icon = "https://nixos.wiki/favicon.ico";
              Alias = "nw";
            }
          ];
          Remove = ["Bing"];
        };
      };
    };
  };
}
