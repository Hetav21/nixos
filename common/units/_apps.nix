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
    ##    neovim
    ##    neovide
    vscode
    vim
    sublime4
    zed-editor_git
    jetbrains.idea-ultimate

    # Programming languages and tools
    go
    lua
    python3
    python3Packages.pip
    uv
    clang
    zig
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    bun
    jdk
    maven
    gcc

    # Frappe Bench
    redis
    wkhtmltopdf
    nginx
    uv
    mariadb
    mongodb-compass

    # Version control and development tools
    ## bruno
    git
    gh
    lazygit
    lazydocker
    gnumake
    coreutils
    nixfmt-rfc-style
    meson
    ninja
    distrobox
    devenv

    # Shell and terminal utilities
    ##    inputs.nixCats.packages.${pkgs.system}.nixCats
    alejandra
    stow
    tmux
    wget
    pandoc
    killall
    eza
    starship
    kitty
    zoxide
    fzf
    tmux
    progress
    tree
    alacritty
    nix-index

    # File management and archives
    yazi
    p7zip
    unzip
    unrar
    file-roller
    ncdu
    duf
    zip

    # System monitoring and management
    htop
    btop
    lm_sensors
    inxi
    nix-output-monitor

    # Network and internet tools
    aria2
    qbittorrent

    # Audio and video
    alsa-utils
    pavucontrol
    ffmpeg
    mpv
    deadbeef-with-plugins
    obs-studio

    # Image and graphics
    gimp
    loupe
    imagemagick
    swww
    waypaper
    imv

    # Productivity and office
    spacedrive
    hugo
    ## obsidian
    onlyoffice-bin

    # Communication and social
    telegram-desktop
    element-desktop
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
    ##    stremio
    # System utilities
    libgcc
    bc
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    virt-viewer
    swappy
    yad
    playerctl
    nh
    ansible
    kdePackages.kwallet

    # Wayland specific
    grim
    slurp
    waybar
    dunst
    wl-clipboard
    swaynotificationcenter

    # File systems
    ntfs3g

    # Downloaders
    yt-dlp
    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet

    # Education
    ## ciscoPacketTracer8
    wireshark
    ventoy

    # Music and streaming
    #    spotify
    youtube-music
    spicetify-cli

    # Miscellaneous
  ];
}
