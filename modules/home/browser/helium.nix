{
  extraLib,
  lib,
  pkgs,
  inputs,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.browser.helium";
  hasCli = false;
  hasGui = true;

  guiConfig = _: {
    home.packages = [
      inputs.helium-flake.packages.${pkgs.system}.default
    ];
  };
})
args
