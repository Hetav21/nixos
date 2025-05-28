{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vscode
    vim
    sublime4
    zed-editor
    code-cursor

    # Programming languages and build tools

    # Version control and development tools
    codex
    hoppscotch
    bruno
    git
    git-lfs
    gh
    mongodb-compass
    distrobox

    # Shell and terminal utilities
    killall
    most
    tree

    # File management and archives
    file-roller

    # System monitoring and management
    htop
    btop

    # Audio and video
    pavucontrol
    obs-studio
    mpv

    # Image and graphics
    loupe
    upscayl

    # Productivity and office
    obsidian
    onlyoffice-bin
    texliveMinimal

    # Gaming and entertainment

    # System utilities

    # File systems
    ntfs3g

    # Fun and customization
    fastfetch
    microfetch

    # Networking

    # Education

    # Miscellaneous
  ];
}
