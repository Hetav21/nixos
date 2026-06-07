{inputs, ...}: {
  imports = [
    inputs.nix-skills.homeManagerModules.default

    # Decoupled subdirectory submodules
    ./development
    ./shell
    ./system

    # GUI modules
    ./desktop
    ./browser
  ];
}
