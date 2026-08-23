{
  extraLib,
  pkgs,
  inputs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.browser.zen";
  hasCli = false;
  hasGui = true;
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  guiConfig = {
    # --- Stylix Theming ---
    stylix.targets.zen-browser = {
      enable = true;
      profileNames = ["${settings.username}"];
    };

    # --- Zen Browser Configuration ---
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      profiles = {
        "${settings.username}" = {
          isDefault = true;
        };
      };

      # --- Browser Policies (https://mozilla.github.io/policy-templates/) ---
      policies = {
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

        # --- Preferences ---
        Preferences = let
          locked = value: {
            "Value" = value;
            "Status" = "locked";
          };
        in {
          "nebula-tab-switch-animation" = locked 4;
          "nebula-tab-loading-animation" = locked 0;
          "zen.view.grey-out-inactive-windows" = locked false;
          "browser.tabs.warnOnClose" = locked false;
        };

        # --- Search Engines ---
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
