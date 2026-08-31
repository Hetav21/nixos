{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.llm";
  imports = [
    ./ollama.nix
    ./vllm.nix
    ./open-webui.nix
  ];
  hasCli = true;
  cliDescription = "Enable all LLM services (CLI)";
  cliChildren = [
    "ollama"
    "vllm"
  ];
  hasGui = true;
  guiDescription = "Enable all LLM GUI configurations";
  guiChildren = [
    "open-webui"
  ];
}
