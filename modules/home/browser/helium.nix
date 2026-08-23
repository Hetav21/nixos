{
  extraLib,
  pkgs,
  inputs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.browser.helium";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Packages ---
    home.packages = [
      inputs.helium-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
