{
  inputs,
  settings,
  ...
}: {
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      settings = settings;
    };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: _prev: {
    nur = inputs.nur.overlays.default;
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
