{
  lib,
  config,
  ...
}: {
  # --- Submodule Imports ---
  imports = [
    ./zen-browser.nix
    ./helium.nix
  ];

  # --- Options ---
  options.home.browser = {
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable all user GUI web browsers";
    };
  };

  # --- Module Wiring ---
  config = {
    home.browser.zen.enableGui = lib.mkDefault config.home.browser.enableGui;
    home.browser.helium.enableGui = lib.mkDefault config.home.browser.enableGui;
  };
}
