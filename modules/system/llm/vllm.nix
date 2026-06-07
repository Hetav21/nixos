{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.llm.vllm";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    lib,
    pkgs,
    pkgs-unstable,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      vllm
    ];
  };
})
args
