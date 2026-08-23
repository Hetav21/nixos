{
  extraLib,
  lib,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.binfmt";
  cliConfig = {
    # --- Emulated Systems ---
    boot.binfmt.emulatedSystems = lib.mkIf (!(config.wsl.enable or false)) [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };
}
