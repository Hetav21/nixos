{inputs, ...}: final: prev: let
  system = prev.stdenv.hostPlatform.system;
  t3code = inputs.t3code.packages.${system};
  heliumFlake = inputs.helium-flake.packages.${system};
  vicinaeExtensions = inputs.vicinae-extensions.packages.${system};
  hetav21Nur =
    (import inputs.nur {
      nurpkgs = prev;
      pkgs = prev;
    }).repos.hetav21;
in {
  # --- T3 Code Nightly Addition ---
  inherit
    (t3code)
    t3code-nightly
    ;

  # --- Helium Browser Addition ---
  inherit
    (heliumFlake)
    helium
    ;

  # --- Vicinae Extensions Addition ---
  inherit vicinaeExtensions;

  # --- Personal Packages (from NUR) ---
  inherit
    (hetav21Nur)
    direnv-nvim
    px0
    wsl-notify-send
    ;
}
