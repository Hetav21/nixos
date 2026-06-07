{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.productivity.latex";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = [
      pkgs.texliveMinimal
    ];
    services.flatpak.packages = [
      "org.texstudio.TeXstudio"
    ];
  };
})
args
