{
  pkgs,
  config,
  ...
}: let
  username = "hetav";
in {
  environment.systemPackages = with pkgs; [lxqt.lxqt-policykit sops];

  sops = {
    age.keyFile = "/etc/nixos/secrets/keys.asc";

    secrets.openai_api_key = {
      sopsFile = ../../secrets/openai_api_key.yaml;

      mode = "0440";
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };
  };

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };
}
