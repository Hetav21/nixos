{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.development";
  imports = [
    ./git.nix
    ./neovim.nix
    ./ssh.nix
    ./agents.nix
    ./misc.nix
    ./editors.nix
  ];
  hasCli = true;
  cliDescription = "Enable all development tools and CLI environments";
  cliChildren = [
    "git"
    "neovim"
    "ssh"
    "agents"
    "misc"
  ];
  hasGui = true;
  guiDescription = "Enable GUI development tools (VSCode, Zed, Compass)";
  guiChildren = [
    "misc"
    "editors"
  ];
}
