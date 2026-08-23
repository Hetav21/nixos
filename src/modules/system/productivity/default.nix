{
  lib,
  config,
  ...
}: {
  # --- Submodules ---
  imports = [
    ./latex.nix
    ./obsidian.nix
    ./office.nix
    ./teams.nix
    ./thunar.nix
  ];

  # --- Options ---
  options.system.productivity = {
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GUI productivity applications";
    };
  };

  # --- Configuration ---
  config = {
    system.productivity.latex.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.obsidian.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.office.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.teams.enableGui = lib.mkDefault config.system.productivity.enableGui;
    system.productivity.thunar.enableGui = lib.mkDefault config.system.productivity.enableGui;
  };
}
