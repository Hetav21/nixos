{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  hardware,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.llm";
  hasGui = true;
  cliConfig = {
    lib,
    pkgs,
    pkgs-unstable,
    hardware,
    ...
  }: let
    isNvidiaEnabled = hardware.nvidia.enable;
    isAmdgpuEnabled = hardware.amdgpu.enable;
    package = pkgs;
  in {
    environment.systemPackages = with package;
      [
        vllm
      ]
      ++ [
        pkgs-unstable.agent-browser
      ];

    environment.variables.AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs-unstable.chromium;

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
  guiConfig = {pkgs, ...}: {
    services.open-webui = {
      enable = true;
      package = pkgs.open-webui;
      openFirewall = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };
  };
})
args
