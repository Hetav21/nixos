{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vscode
    vim
    sublime4
    zed-editor
    code-cursor

    # Programming languages and build tools
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    bun
    go
    lua
    zig
    rustup
    rustc
    python3
    jdk
    maven
    gcc
    clang
    gnumake
    progress
    meson
    ninja

    # Version control and development tools
    codex
    hoppscotch
    bruno
    python3Packages.huggingface-hub
    git
    git-lfs
    gh
    mongodb-compass
    distrobox
    devenv

    # Shell and terminal utilities
    openssl
    coreutils
    alacritty
    ghostty
    alejandra
    wget
    killall
    tree
    stow
    pandoc

    # File management and archives
    p7zip
    unzip
    unrar
    file-roller
    zip

    # System monitoring and management
    htop
    btop

    # Audio and video
    pavucontrol
    ffmpeg
    obs-studio
    mpv

    # Image and graphics
    loupe
    upscayl

    # Productivity and office
    obsidian
    onlyoffice-bin
    texlive.combined.scheme-full

    # Gaming and entertainment

    # System utilities
    libgcc
    libnotify
    v4l-utils
    pciutils
    pkg-config

    # File systems
    ntfs3g

    # Clipboard managers
    cliphist

    # Fun and customization
    fastfetch
    microfetch
    onefetch

    # Networking

    # Education

    # Miscellaneous
  ];
}
