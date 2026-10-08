{
  pkgs,
  inputs ? {},
  ...
}: {
  # --- Standalone Tools ---
  gitignore = pkgs.callPackage ./gitignore {};
  antigravity-wsl-shim = pkgs.callPackage ./antigravity-wsl-shim {};

  # --- Agent & AI Resources ---
  agent-sources = pkgs.callPackage ./agent-sources {inherit inputs;};
}
