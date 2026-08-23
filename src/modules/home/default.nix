{inputs, ...}: {
  # --- Submodule Imports ---
  imports = [
    inputs.nix-skills.homeManagerModules.default

    # Submodules
    ./development
    ./shell
    ./system
    ./desktop
    ./browser
  ];
}
