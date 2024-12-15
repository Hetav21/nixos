{
  lib,
  config,
  pkgs,
  ...
}: let
  userName = "hetav";
  userDescription = "Hetav Shah";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      #      shell = pkgs.zsh;
      shell = pkgs.nushell;
      extraGroups = ["wheel" "mlocate" "docker" "wireshark"];
    };
    ## programs.zsh.enable = true;
  };
}
