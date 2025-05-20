{pkgs, ...}: let
  userName = "hetav";
  userDescription = "Hetav Shah";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.nushell;
      extraGroups = [
        "wheel"
        "mlocate"
        "docker"
        "wireshark"
      ];
    };
  };
}
