{
  pkgs,
  settings,
  ...
}: {
  config = {
    users.users.${settings.username} = {
      isNormalUser = true;
      description = "Normal User";
      shell = pkgs.unstable.nushell;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
