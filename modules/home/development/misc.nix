{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.misc";
  hasCli = true;
  hasGui = true;
  cliConfig = _: {
    home.packages =
      (with pkgs; [
        awscli2
        distrobox
      ])
      ++ (with pkgs-unstable; [
        lazygit
        lazydocker
      ]);
  };

  guiConfig = _: {
    home.packages = with pkgs; [
      mongodb-compass
      hoppscotch
      bruno
    ];
  };
})
args
