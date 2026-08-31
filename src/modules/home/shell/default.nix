{
  extraLib,
  lib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.shell";
  imports = [
    ./shells.nix
    ./tmux.nix
    ./tools.nix
    ./terminals.nix
    ./newsboat.nix
  ];
  hasCli = true;
  cliDescription = "Enable all shell environments and CLI tools";
  cliChildren = [
    "shells"
    "tmux"
    "tools"
    "newsboat"
  ];
  hasGui = true;
  guiDescription = "Enable terminal GUI configurations (Alacritty, Ghostty)";
  guiChildren = [
    "terminals"
  ];
  extraConfig = {config, ...}:
    lib.mkIf (config.home.shell.enable or false) {
      home.shell.enableShellIntegration = lib.mkDefault true;
    };
}
