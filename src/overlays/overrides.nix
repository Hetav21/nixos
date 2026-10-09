{
  inputs,
  ...
}: final: _prev: let
  unstable = import inputs.nixpkgs-unstable {
    system = final.stdenv.hostPlatform.system;
    inherit (final) config;
  };
in {
  # --- GUI & Desktop Applications ---
  inherit
    (unstable)
    brave
    discord
    ghostty
    google-chrome
    tela-circle-icon-theme
    vesktop
    vscode
    zed-editor
    ;

  # --- Development & VCS Tools ---
  inherit
    (unstable)
    delta
    gitFull
    git-lfs
    jujutsu
    lazydocker
    lazygit
    lazyjj
    ;

  # --- Shell & Terminal Utilities ---
  inherit
    (unstable)
    atuin
    bat
    carapace
    direnv
    eza
    fd
    fzf
    mise
    nix-direnv
    nix-your-shell
    ripgrep
    starship
    yazi
    zoxide
    ;

  # --- System & Hardware Tools ---
  inherit
    (unstable)
    lact
    nh
    ;
}
