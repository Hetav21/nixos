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
  ];

  # Flatpak
  services.flatpak.packages = [
    "com.sublimetext.three" # Sublime Text Editor
  ];
}
