{
  lib,
  config,
  ...
}: {
  # --- Browser Submodules ---
  imports = [
    ./browseros.nix
    ./brave.nix
    ./chrome.nix
    ./edge.nix
  ];

  # --- Options ---
  options.system.browser = {
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable all GUI web browsers";
    };
  };

  # --- Default Propagations ---
  config = {
    system.browser.browseros.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.brave.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.chrome.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.edge.enableGui = lib.mkDefault config.system.browser.enableGui;
  };
}
