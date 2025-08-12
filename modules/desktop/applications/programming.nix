{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    unstable.vscode
    unstable.zed-editor
    unstable.code-cursor

    # Programming languages and build tools

    # Version control and development tools
    unstable.codex
    unstable.claude-code
    unstable.gemini-cli
    unstable.hoppscotch
    unstable.bruno
    awscli2
    gh
    mongodb-compass
    distrobox
  ];

  # Git configuration
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    lfs = {
      enable = true;
      package = pkgs.unstable.git-lfs;
    };
  };

  # Flatpak
  services.flatpak.packages = [
    "com.sublimetext.three" # Sublime Text Editor
  ];
}
