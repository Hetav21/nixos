{
  lib,
  config,
  hardware ? {},
  ...
}: {
  # --- Profile Options ---
  options.profiles.system.desktop = {
    enable = lib.mkEnableOption "Desktop profile with all features";
  };

  # --- Profile Configuration ---
  config = lib.mkIf config.profiles.system.desktop.enable {
    # --- Core System ---
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;

    # --- Virtualisation ---
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

    # --- Networking ---
    system.network = {
      base.enable = true;
      applet.enableGui = true;
      wireshark.enableGui = false;
    };

    # --- Storage & File Sharing ---
    system.storage = {
      ntfs.enable = false;
      syncthing.enable = false;
      rclone.enable = false;
      localsend.enableGui = true;
      megasync.enableGui = true;
      onedrive.enableGui = false;
    };

    # --- Media & Graphics ---
    system.media = {
      mpv.enable = true;
      pavucontrol.enableGui = true;
      obs.enableGui = true;
      upscayl.enableGui = true;
      graphics.enableGui = true;
      spotify.enableGui = true;
      stremio.enableGui = true;
    };

    # --- Productivity ---
    system.productivity = {
      thunar.enableGui = true;
      office.enableGui = true;
      obsidian.enableGui = true;
      teams.enableGui = false;
      latex.enableGui = true;
    };

    # --- Communication ---
    system.communication = {
      zoom.enableGui = false;
      thunderbird.enableGui = true;
      discord.enableGui = true;
    };

    # --- Web Browsers ---
    system.browser = {
      brave.enableGui = true;
      chrome.enableGui = true;
      edge.enableGui = true;
    };

    # --- Base Services ---
    system.baseservices = {
      locate.enable = true;
      cron.enable = true;
      gnupg.enable = true;
      flatpak.enableGui = true;
    };

    # --- Local LLM & AI ---
    system.llm = {
      ollama.enable = false;
      vllm.enable = false;
      open-webui.enableGui = false;
    };

    # --- Desktop Environment & Hardware ---
    system.desktopEnvironment.enableGui = true;
    system.hardware.base.enable = true;
    system.misc.diskDecryption.enable = false;

    # --- Hardware Drivers ---
    drivers.nvidia.enable = hardware.nvidia.enable or false;
    drivers.intel.enable = hardware.intel.enable or false;
    drivers.amdgpu.enable = hardware.amdgpu.enable or false;
    drivers.asus.enable = hardware.asus.enable or false;
  };
}
