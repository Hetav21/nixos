{
  lib,
  config,
  ...
}: {
  imports = [
    ./shells.nix
    ./tmux.nix
    ./tools.nix
    ./terminals.nix
  ];

  options = {
    home.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all shell environments and CLI tools";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable terminal GUI configurations (Alacritty, Ghostty)";
      };
    };
  };

  config = lib.mkMerge [
    {
      home.shell.shells.enable = lib.mkDefault config.home.shell.enable;
      home.shell.tmux.enable = lib.mkDefault config.home.shell.enable;
      home.shell.tools.enable = lib.mkDefault config.home.shell.enable;
      home.shell.terminals.enableGui = lib.mkDefault config.home.shell.enableGui;
    }
    (lib.mkIf config.home.shell.enable {
      home.shell.enableShellIntegration = lib.mkDefault true;
    })
  ];
}
