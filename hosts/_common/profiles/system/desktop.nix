# Desktop system profile with all features enabled
# Includes: all system modules, desktop environment, applications, hardware support
{
  lib,
  config,
  hardware ? {},
  ...
}: {
  options.profiles.system.desktop = {
    enable = lib.mkEnableOption "Desktop profile with all features";
  };

  config = lib.mkIf config.profiles.system.desktop.enable {
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;

    # Enable all categorized modules with both CLI and GUI
    system.virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = true;
      virt-manager.enableGui = true;
      waydroid.enableGui = false;
      binfmt.enable = false;
      android.enable = false;
      guest.enable = false;
    };
    system.network = {
      base.enable = true;
      applet.enableGui = true;
      wireshark.enableGui = false;
    };
    system.storage = {
      ntfs.enable = false;
      syncthing.enable = false;
      rclone.enable = false;
      localsend.enableGui = true;
      megasync.enableGui = true;
      onedrive.enableGui = false;
    };
    system.media = {
      mpv.enable = true;
      pavucontrol.enableGui = true;
      obs.enableGui = true;
      upscayl.enableGui = true;
      graphics.enableGui = true;
      spotify.enableGui = true;
      stremio.enableGui = true;
    };
    system.productivity = {
      thunar.enableGui = true;
      office.enableGui = true;
      obsidian.enableGui = true;
      teams.enableGui = false;
      latex.enableGui = true;
    };
    system.communication = {
      zoom.enableGui = false;
      thunderbird.enableGui = true;
      discord.enableGui = true;
    };
    system.browser = {
      browseros.enableGui = true;
      brave.enableGui = true;
      chrome.enableGui = true;
      edge.enableGui = true;
    };
    system.baseservices = {
      locate.enable = true;
      cron.enable = true;
      gnupg.enable = true;
      flatpak.enableGui = true;
    };
    system.llm = {
      ollama.enable = false;
      vllm.enable = false;
      open-webui.enableGui = false;
    };
    system.desktopEnvironment.enableGui = true;

    # Enable base hardware modules (audio, bluetooth, input, etc.)
    system.hardware.base.enable = true;

    # Enable misc modules
    system.misc.diskDecryption.enable = false;

    # Enable hardware drivers based on hardware config
    drivers.nvidia.enable = hardware.nvidia.enable or false;
    drivers.intel.enable = hardware.intel.enable or false;
    drivers.amdgpu.enable = hardware.amdgpu.enable or false;
    drivers.asus.enable = hardware.asus.enable or false;
  };
}
