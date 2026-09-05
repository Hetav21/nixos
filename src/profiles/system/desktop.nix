{
  extraLib,
  hardware ? {},
  ...
} @ args:
extraLib.modules.mkProfileModule args {
  name = "profiles.system.desktop";
  description = "Desktop profile with all features";

  profileConfig = {
    # --- Core System ---
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;
    system.secrets.enable = true;

    # --- Virtualisation ---
    system.virtualisation = {
      docker.enable = true;
      # podman.enable = true; # Daemonless container engine and compose runner
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
      # latex.enableGui = true; # LaTeX distribution and IDE
    };

    # --- Communication ---
    system.communication = {
      zoom.enableGui = false;
      discord.enableGui = true;
    };

    # --- Web Browsers ---
    system.browser = {
      brave.enableGui = true;
      chrome.enableGui = true;
      edge.enableGui = true;
    };

    # --- Miscellaneous Utilities ---
    system.misc = {
      locate.enable = true;
      cron.enable = true;
      gnupg.enable = true;
      disk-decryption.enable = false;
    };

    # --- Local LLM & AI ---
    system.llm = {
      ollama.enable = false;
      vllm.enable = false;
      open-webui.enableGui = false;
    };

    # --- Desktop Environment & Hardware ---
    system.desktop = {
      enable = true;
      flatpak.enableGui = true;
    };
    system.hardware.base.enable = true;

    # --- Hardware Drivers ---
    drivers.nvidia.enable = hardware.nvidia.enable or false;
    drivers.nvidia.prime.offload.enable = hardware.nvidia.prime.offload.enable or false;
    drivers.nvidia.prime.sync.enable = hardware.nvidia.prime.sync.enable or false;
    drivers.intel.enable = hardware.intel.enable or false;
    drivers.amdgpu.enable = hardware.amdgpu.enable or false;
    drivers.asus.enable = hardware.asus.enable or false;
  };
}
