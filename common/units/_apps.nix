{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vscode
    vim
    sublime4
    zed-editor

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
    bruno
    git
    gh
    mongodb-compass
    distrobox
    devenv

    # Shell and terminal utilities
    coreutils
    alacritty
    ghostty
    tmux
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

    # Network and internet tools
    yt-dlp
    qbittorrent

    # Audio and video
    pavucontrol
    ffmpeg
    obs-studio
    mpv

    # Image and graphics
    loupe

    # Productivity and office
    obsidian
    onlyoffice-bin

    # Communication and social
    thunderbird
    zoom-us
    discord
    vesktop

    # Browsers
    firefox
    brave
    chromium
    inputs.zen-browser.packages."${system}".default

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
    wireshark

    # Music and streaming
    youtube-music
    spicetify-cli

    # Miscellaneous
  ];
}
