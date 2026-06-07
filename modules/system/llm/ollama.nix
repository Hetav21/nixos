{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.llm.ollama";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    lib,
    pkgs,
    hardware,
    ...
  }: let
    isNvidiaEnabled = hardware.nvidia.enable;
    isAmdgpuEnabled = hardware.amdgpu.enable;
    package = pkgs;
  in {
    services.ollama = {
      enable = true;
      environmentVariables = {
        ## Enable debug logging
        # OLLAMA_DEBUG = "1";
        ## Allowing connections from web browsers
        OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*,safari-web-extension://*";
      };
      ## Preload models, see https://ollama.com/library
      # loadModels = ["qwen3:8b"];
      ## Use GPU acceleration if available
      package =
        if isNvidiaEnabled
        then package.ollama-cuda
        else if isAmdgpuEnabled
        then package.ollama-rocm
        else package.ollama;
      acceleration =
        if isNvidiaEnabled
        then "cuda"
        else if isAmdgpuEnabled
        then "rocm"
        else null;
    };
  };
})
args
