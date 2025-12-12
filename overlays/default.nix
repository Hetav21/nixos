{
  inputs,
  settings,
  ...
}: {
  # Overlay custom derivations into nixpkgs so you can use pkgs.custom.<name>
  additions = final: _prev: {
    custom = import ../pkgs {
      pkgs = final;
      settings = settings;
    };
  };

  # NUR overlay - provides pkgs.nur-packages
  # https://wiki.nixos.org/wiki/Overlays
  modifications = _final: _prev: {
    nur = inputs.nur.overlays.default;
  };
}
