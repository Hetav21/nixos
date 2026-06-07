{
  lib,
  config,
  ...
}: {
  imports = [
    ./thunar.nix
    ./office.nix
    ./obsidian.nix
    ./teams.nix
    ./latex.nix
  ];

  options = {
    system.productivity = {
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI productivity applications";
      };
    };
  };

  config = {
    system.productivity.thunar.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.office.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.obsidian.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.teams.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.latex.enableGui = lib.mkDefault config.system.productivity.enableGui;
  };
}
