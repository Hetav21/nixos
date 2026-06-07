{
  extraLib,
  lib,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.binfmt";
  cliConfig = {
    boot.binfmt.emulatedSystems = lib.mkIf (!(config.wsl.enable or false)) [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };
})
args
