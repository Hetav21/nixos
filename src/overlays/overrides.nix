{
  inputs,
  ...
}: final: _prev: let
  unstable = import inputs.nixpkgs-unstable {
    system = final.stdenv.hostPlatform.system;
    inherit (final) config;
  };
in {
  # --- User-selected Unstable Overrides ---
  inherit
    (unstable)
    atuin
    bat
    brave
    carapace
    direnv
    google-chrome
    lact
    nix-direnv
    nix-your-shell
    vscode
    yazi
    zed-editor
    zoxide
    ;
}
