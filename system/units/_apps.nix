{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    latest.vscode
    latest.zed-editor
    latest.code-cursor

    # Programming languages and build tools

    # Version control and development tools
    awscli2
    latest.codex
    latest.claude-code
    latest.gemini-cli
    latest.hoppscotch
    latest.bruno
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
    impala
    btop

    # Audio and video
    pavucontrol
    obs-studio
    mpv
    yt-dlp

    # Image and graphics

    # Productivity and office
    latest.obsidian
    texliveMinimal

    # Gaming and entertainment

    # System utilities
    vim

    # File systems
    ntfs3g

    # Fun and customization

    # Networking

    # Education

    # Miscellaneous
  ];
}
