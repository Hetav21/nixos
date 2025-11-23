{
  pkgs,
  hardware,
  ...
}: let
  isNvidiaEnabled = hardware.nvidia.enable;
  isAmdgpuEnabled = hardware.amdgpu.enable;
  package = pkgs.unstable;
in {
  services = {
    ollama = {
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

    open-webui = {
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
}
