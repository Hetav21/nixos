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
      shell =
        if isWslEnabled
        then pkgs.fish
        else pkgs.nushell;
      ignoreShellProgramCheck =
        if isWslEnabled
        then true
        else false;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
