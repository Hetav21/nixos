{
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./neovim.nix
    ./ssh.nix
    ./agents.nix
    ./misc.nix
  ];

  options = {
    home.development = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all development tools and CLI environments";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GUI development tools (VSCode, Zed, Compass)";
      };
    };
  };

  config = {
    home.development.git.enable = lib.mkDefault config.home.development.enable;
    home.development.neovim.enable = lib.mkDefault config.home.development.enable;
    home.development.ssh.enable = lib.mkDefault config.home.development.enable;
    home.development.agents.enable = lib.mkDefault config.home.development.enable;
    home.development.misc.enable = lib.mkDefault config.home.development.enable;
    home.development.misc.enableGui = lib.mkDefault config.home.development.enableGui;
  };
}
