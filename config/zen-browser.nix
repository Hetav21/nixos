{
  pkgs,
  inputs,
  settings,
  ...
}: {
  imports = [
    ../pkgs/zen-nebula/home
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  zen-nebula = {
    enable = false; # set to true if you want to use nebula theme from pkgs
    profile = settings.username;
  };

  stylix.targets.zen-browser = {
    enable = true; # set to true if you want to use nebula theme from Stylix
    profileNames = ["${settings.username}"];
  };

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
    profiles = {
      "${settings.username}" = {
        isDefault = true;
      };
    };
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
      Preferences = {
        "browser.tabs.warnOnClose" = {
          "Value" = false;
          "Status" = "locked";
        };
        "zen.view.grey-out-inactive-windows" = {
          "Value" = false;
          "Status" = "locked";
        };
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
        Remove = [
          "Bing"
        ];
      };
    };
  };
}
