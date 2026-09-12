{
  extraLib,
  ...
}@args:
extraLib.modules.mkCategoryModule args {
  name = "home.media";
  imports = [
    ./mpv.nix
  ];
  hasCli = true;
  cliChildren = [ "mpv" ];
}
