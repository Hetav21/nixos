{
  extraLib,
  pkgs,
  hardware ? {},
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.llm.ollama";
  hasCli = true;
  hasGui = false;
  cliConfig = let
    isNvidiaEnabled = (hardware ? nvidia) && hardware.nvidia.enable;
    isAmdgpuEnabled = (hardware ? amdgpu) && hardware.amdgpu.enable;
  in {
    # --- Ollama Service ---
    services.ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*,safari-web-extension://*";
      };
      package =
        if isNvidiaEnabled
        then pkgs.ollama-cuda
        else if isAmdgpuEnabled
        then pkgs.ollama-rocm
        else pkgs.ollama;
      acceleration =
        if isNvidiaEnabled
        then "cuda"
        else if isAmdgpuEnabled
        then "rocm"
        else null;
    };
  };
}
