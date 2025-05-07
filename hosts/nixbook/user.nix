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
    programs.fish.enable = true;

    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.fish;
      # shell = pkgs.nushell;
      extraGroups = ["wheel" "mlocate" "docker" "wireshark"];
    };
  };
}
