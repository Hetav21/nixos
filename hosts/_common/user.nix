{
  lib,
  pkgs,
  config,
  settings,
  ...
}: let
  isWslEnabled = config.profiles.system.wsl-minimal.enable or false;
in {
  config = {
    users.users.${settings.username} = {
      isNormalUser = true;
      description = "Normal User";
      # WSL: Use fish as login shell for IDE compatibility in wsl
      shell =
        if isWslEnabled
        then pkgs.fish
        else pkgs.nushell;
      # Make sure shell's defined using home-manager
      ignoreShellProgramCheck = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
