{
  pkgs,
  hardware,
  ...
}: let
  isNvidiaEnabled = hardware.nvidia.enable;
  isAmdgpuEnabled = hardware.amdgpu.enable;
in {
  services = {
    ollama = {
      enable = true;

      package =
        if isNvidiaEnabled
        then pkgs.master.ollama-cuda
        else if isAmdgpuEnabled
        then pkgs.master.ollama-rocm
        else pkgs.master.ollama;
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
