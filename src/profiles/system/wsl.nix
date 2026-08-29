{
  extraLib,
  ...
} @ args:
extraLib.modules.mkProfileModule args {
  name = "profiles.system.wsl";
  description = "WSL profile with CLI/TUI only";

  profileConfig = {
    # --- Core System ---
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;
    system.secrets.enable = true;

    # --- Theming ---
    system.stylix.enable = true;

    # --- CLI/TUI Tools & Virtualisation ---
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

    # --- Storage & Base Services ---
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
    # --- Miscellaneous Utilities ---
    system.misc = {
      locate.enable = true;
      cron.enable = true;
      gnupg.enable = true;
      disk-decryption.enable = false;
    };
    system.llm = {
      ollama.enable = false;
      vllm.enable = false;
      open-webui.enableGui = false;
    };

    # --- Disabled Desktop & Hardware Components ---
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
      brave.enableGui = false;
      chrome.enableGui = false;
      edge.enableGui = false;
    };
    system.desktop.enable = false;
    system.hardware.base.enable = false;
    system.desktop.security.enable = false;
  };
}
