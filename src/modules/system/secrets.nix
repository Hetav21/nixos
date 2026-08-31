{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.secrets";
  hasGui = false;
  cliConfig = {
    # --- System Packages ---
    environment.systemPackages = [pkgs.sops];

    # --- Sops Secret Decryption ---
    sops = {
      age.keyFile = "${settings.setup_dir}/secrets/keys.asc";

      secrets.openai_api_key = {
        sopsFile = extraLib.paths.secret "openai_api_key.yaml";
        mode = "0440";
        owner = settings.username;
        group = "users";
      };

      secrets.context7_api_key = {
        sopsFile = extraLib.paths.secret "context7_api_key.yaml";
        mode = "0440";
        owner = settings.username;
        group = "users";
      };
    };
  };
}
