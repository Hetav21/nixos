# WSL system profile (CLI/TUI only, no GUI)
# Includes: core system modules only, all desktop features disabled
{
  lib,
  config,
  ...
}: {
  options.profiles.system.wsl = {
    enable = lib.mkEnableOption "WSL profile with CLI/TUI only";
  };

  config = lib.mkIf config.profiles.system.wsl.enable {
    # Core system (always needed)
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;

    # Enable Stylix for fonts and TUI theming
    system.stylix.enable = true;

    # CLI/TUI tools only (no GUI)
    system.virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = false;
      binfmt.enable = false;
      android.enable = false;
      virt-manager.enableGui = false;
      waydroid.enableGui = false;
      guest.enable = false;
    };
    system.network = {
      base.enable = false;
      applet.enableGui = false;
      wireshark.enableGui = false;
    };
    system.storage = {
      ntfs.enable = false;
      syncthing.enable = false;
      rclone.enable = false;
      localsend.enableGui = false;
      megasync.enableGui = false;
      onedrive.enableGui = false;
    };
    system.baseservices = {
      locate.enable = true;
      cron.enable = true;
      gnupg.enable = true;
      flatpak.enableGui = false;
    };
    system.llm = {
      ollama.enable = false;
      vllm.enable = false;
      open-webui.enableGui = false;
    };

    # Disable all GUI components
    system.media = {
      mpv.enable = false;
      pavucontrol.enableGui = false;
      obs.enableGui = false;
      upscayl.enableGui = false;
      graphics.enableGui = false;
      spotify.enableGui = false;
      stremio.enableGui = false;
    };
    system.productivity = {
      thunar.enableGui = false;
      office.enableGui = false;
      obsidian.enableGui = false;
      teams.enableGui = false;
      latex.enableGui = false;
    };
    system.communication = {
      zoom.enableGui = false;
      thunderbird.enableGui = false;
      discord.enableGui = false;
    };
    system.browser = {
      browseros.enableGui = false;
      brave.enableGui = false;
      chrome.enableGui = false;
      edge.enableGui = false;
    };
    system.desktopEnvironment.enableGui = false;

    # Disable base hardware modules (not needed for WSL)
    system.hardware.base.enable = false;

    # Disable desktop sub-modules (not needed for WSL)
    system.desktop.security.enable = false;

    # Disable misc modules (not needed for WSL)
    system.misc.diskDecryption.enable = false;
  };
}
