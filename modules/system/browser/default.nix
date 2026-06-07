{
  lib,
  config,
  ...
}: {
  imports = [
    ./browseros.nix
    ./brave.nix
    ./chrome.nix
    ./edge.nix
  ];

  options = {
    system.browser = {
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI web browsers";
      };
    };
  };

  config = {
    system.browser.browseros.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.brave.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.chrome.enableGui = lib.mkDefault config.system.browser.enableGui;
    system.browser.edge.enableGui = lib.mkDefault config.system.browser.enableGui;
  };
}
