{
  pkgs,
  config,
  settings,
  extraLib,
  ...
}: {
  # --- System Packages ---
  environment.systemPackages = with pkgs; [sops];

  # --- Sops Secret Decryption ---
  sops = {
    age.keyFile = "${settings.setup_dir}secrets/keys.asc";

    secrets.openai_api_key = {
      sopsFile = extraLib.paths.secret "openai_api_key.yaml";
      mode = "0440";
      owner = config.users.users.${settings.username}.name;
      group = config.users.users.${settings.username}.group;
    };

    secrets.context7_api_key = {
      sopsFile = extraLib.paths.secret "context7_api_key.yaml";
      mode = "0440";
      owner = config.users.users.${settings.username}.name;
      group = config.users.users.${settings.username}.group;
    };
  };
}
