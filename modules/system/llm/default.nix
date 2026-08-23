{
  lib,
  config,
  ...
}: {
  # --- LLM Submodules ---
  imports = [
    ./ollama.nix
    ./vllm.nix
    ./open-webui.nix
  ];

  # --- Options ---
  options.system.llm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable all LLM services (CLI)";
    };
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable all LLM GUI configurations";
    };
  };

  # --- Default Propagations ---
  config = {
    system.llm.ollama.enable = lib.mkDefault config.system.llm.enable;
    system.llm.vllm.enable = lib.mkDefault config.system.llm.enable;
    system.llm.open-webui.enableGui = lib.mkDefault config.system.llm.enableGui;
  };
}
