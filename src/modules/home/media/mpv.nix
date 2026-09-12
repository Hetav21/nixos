{
  extraLib,
  lib,
  pkgs,
  ...
}@args:
extraLib.modules.mkModule args {
  name = "home.media.mpv";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- MPV Media Player ---
    programs.mpv = {
      enable = true;

      extraMakeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath [
          pkgs.wl-clipboard
        ])
      ];

      # --- Scripts ---
      scripts = with pkgs.mpvScripts; [
        modernx
        thumbfast
        autoload
        sponsorblock-minimal
        smart-copy-paste-2
        seekTo
        mpv-playlistmanager
        visualizer
      ];

      # --- Script Options ---
      scriptOpts = {
        osc = {
          scalewindowed = 0.8;
          scalefullscreen = 0.8;
          hidetimeout = 300;
          showonpause = false;
        };
        thumbfast = {
          max_height = 250;
          max_width = 250;
          spawn_first = true;
          network = true;
          hwdec = true;
        };
        SmartCopyPaste_II = {
          device = "linux";
          linux_copy = "wl-copy";
          linux_paste = "wl-paste";
        };
      };

      # --- Configuration (mpv.conf) ---
      config = {
        # General
        profile = "high-quality";
        vo = "gpu";
        gpu-api = "vulkan";
        fullscreen = true;
        taskbar-progress = false;
        force-seekable = true;
        keep-open = "always";
        reset-on-next-file = "pause";

        # Scalers & Shaders
        scale = "ewa_lanczossharp";
        dscale = "mitchell";
        cscale = "ewa_lanczossoft";
        gpu-shader-cache-dir = "~~/shaders/cache";
        glsl-shader = [
          "~~/shaders/FSRCNNX_x2_16-0-4-1.glsl"
          "~~/shaders/SSimDownscaler.glsl"
        ];

        # Cache
        cache = true;
        cache-on-disk = true;
        cache-secs = 36000;
        demuxer-max-bytes = "15G";
        demuxer-readahead-secs = 36000;

        # Debanding
        deband = false;
        deband-iterations = 2;
        deband-threshold = 64;
        deband-range = 17;
        deband-grain = 12;

        # On Screen Display & Controller
        osd-bar = false;
        osc = false;
        border = false;
        cursor-autohide-fs-only = true;
        cursor-autohide = 300;
        osd-level = 1;
        osd-duration = 1000;
        hr-seek = true;

        osd-font-size = 20;
        osd-border-size = 0.6;
        osd-blur = 0.2;

        # Language Priority
        alang = "ja,jp,jpn,en,eng";
        slang = "en,eng";

        # Audio
        volume = 100;
        audio-file-auto = "fuzzy";
        volume-max = 200;
        audio-pitch-correction = true;

        # Subtitles
        demuxer-mkv-subtitle-preroll = true;
        sub-ass-vsfilter-blur-compat = false;
        sub-fix-timing = false;
        sub-auto = "fuzzy";
        sub-font-size = 40;
        sub-color = "#FFFFFFFF";
        sub-border-color = "#FF000000";
        sub-border-size = 2.0;
        sub-shadow-offset = 0;
        sub-spacing = 0.0;

        # Screenshot
        screenshot-format = "png";
        screenshot-high-bit-depth = true;
        screenshot-png-compression = 1;
        screenshot-directory = "~/Pictures/mpv-screenshots";
        screenshot-template = "%f-%wH.%wM.%wS.%wT-#%#00n";
      };

      # --- Profiles ---
      profiles = {
        HDR = {
          profile-desc = "Tone mapping using reinhard";
          profile-restore = "copy-equal";
          tone-mapping = "reinhard";
          tone-mapping-param = 0.6;
          hdr-compute-peak = false;
          blend-subtitles = "video";
        };
        WEB-DL = {
          profile-desc = "WEB-DL Anime (HatSubs, SubsPlease, HorribleSubs, Erai-raws)";
          profile-cond = ''string.match(p.filename, "HatSubs")~=nil or string.match(p.filename, "SubsPlease")~=nil or string.match(p.filename, "HorribleSubs")~=nil or string.match(p.filename, "Erai%-raws")~=nil'';
          deband = true;
          glsl-shaders = "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl";
        };
      };

      # --- Keybindings (input.conf) ---
      bindings = {
        # General
        k = "cycle ontop";

        # Playback Speed Controls
        "[" = "add speed -0.1";
        "]" = "add speed +0.1";
        "{" = "multiply speed 0.5";
        "}" = "multiply speed 2.0";
        BS = "set speed 1.0";
        "\\" = "cycle-values speed 1.0 1.25 1.5 1.8 2.0";
        "Alt+1" = "set speed 1.0";
        "Alt+2" = "set speed 1.25";
        "Alt+3" = "set speed 1.5";
        "Alt+4" = "set speed 1.8";
        "Alt+5" = "set speed 2.0";

        # Video
        d = "cycle deband";
        D = "cycle deinterlace";
        n = "cycle video-unscaled";
        C = ''cycle-values video-aspect-override "16:9" "4:3" "2.35:1" "-1"'';

        # Audio
        a = "cycle audio";
        A = "cycle audio down";
        WHEEL_UP = "add volume 2";
        WHEEL_DOWN = "add volume -2";
        UP = "add volume 2";
        DOWN = "add volume -2";
        x = "add audio-delay -0.05";
        X = "add audio-delay +0.05";

        # Subtitles
        "Shift+g" = "add sub-scale +0.05";
        "Shift+f" = "add sub-scale -0.05";
        E = "add sub-gauss +0.1";
        R = "add sub-gauss -0.1";
        z = "add sub-delay -0.05";
        Z = "add sub-delay +0.05";
        u = "cycle sub-gray";
        U = "cycle blend-subtitles";
        p = "cycle sub-fix-timing";
        g = "sub-reload";
        l = ''cycle-values sub-ass-override "yes" "force" "no"'';

        # Script Bindings
        c = "script-binding cycle-visualizer";
        "ctrl+S" = "script-binding toggle-seeker";
        "ctrl+v" = "script-binding paste-timestamp";
        "alt+b" = "script-binding sponsorblock";

        # Optimized GLSL Shaders (Anime4K)
        "CTRL+1" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
        "CTRL+2" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
        "CTRL+3" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
        "CTRL+4" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
        "CTRL+5" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
        "CTRL+6" =
          ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
        "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      };
    };
  };
}
