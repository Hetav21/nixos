{inputs, ...}: final: prev: let
  system = prev.stdenv.hostPlatform.system;
  t3code = inputs.t3code.packages.${system};
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

  # --- Personal Packages (from NUR) ---
  inherit
    (hetav21Nur)
    direnv-nvim
    px0
    wsl-notify-send
    ;
}
