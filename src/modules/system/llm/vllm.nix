{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.llm.vllm";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- vLLM ---
    environment.systemPackages = [
      pkgs.vllm
    ];
  };
}
