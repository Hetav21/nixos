{
  pkgs,
  config,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [sops];

  sops = {
    age.keyFile = "/etc/nixos/secrets/keys.asc";

    secrets.openai_api_key = {
      sopsFile = ./openai_api_key.yaml;

      mode = "0440";
      owner = config.users.users.${settings.username}.name;
      group = config.users.users.${settings.username}.group;
    };
  };
}
