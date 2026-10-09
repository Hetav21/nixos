{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.nix.ld";
  hasGui = false;
  cliConfig = {
    # --- Nix-LD Dynamic Linker Support ---
    programs.nix-ld = {
      enable = true;

      # Merged with the NixOS base set (C++ runtime, udev, compression, TLS, ...)
      libraries = with pkgs; [
        # T3 Code preview browser: T3 runs its own downloaded headless Chrome
        # (~/.t3/tools/chrome-headless-shell/) and has no option to use a Nix-built one.
        # Mirrors DEBIAN_PACKAGES in T3's apps/server/src/preview/PreviewBrowserHost.ts;
        # re-check it when T3 bumps its Chrome version
        glib
        nspr
        nss
        at-spi2-core # ATK, ATK bridge and AT-SPI
        dbus
        expat
        alsa-lib
        libgbm
        libxkbcommon

        # X11 client libraries the T3 browser links even when headless
        libx11
        libxcb
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
      ];

      # Find missing libraries from binary error messages using:
      #   nix run github:nix-community/nix-index-database <missinglib.so>
      #
      # Reference library list (uncomment packages as needed):
      # libraries = with pkgs; [
      #   stdenv.cc.cc
      #   openssl
      #   libGL
      #   libva
      #   pipewire
      #   libelf
      #
      #   # Common Desktop / GTK
      #   glib
      #   gtk2
      #   gtk3
      #   bzip2
      #   libgbm
      #   nspr
      #   nss
      #   cups
      #   libcap
      #   SDL2
      #   libusb1
      #   dbus-glib
      #   ffmpeg
      #   libudev0-shim
      #
      #   # X11 / Wayland
      #   xorg.libX11
      #   xorg.libXcomposite
      #   xorg.libXcursor
      #   xorg.libXdamage
      #   xorg.libXext
      #   xorg.libXfixes
      #   xorg.libXft
      #   xorg.libXi
      #   xorg.libXinerama
      #   xorg.libXmu
      #   xorg.libXrandr
      #   xorg.libXrender
      #   xorg.libXScrnSaver
      #   xorg.libXt
      #   xorg.libXtst
      #   xorg.libXxf86vm
      #   xorg.libxcb
      #   xorg.libxshmfence
      #   xorg.libSM
      #   xorg.libICE
      #
      #   # Media, Graphics & Audio
      #   alsa-lib
      #   atk
      #   cairo
      #   dbus
      #   expat
      #   flac
      #   fontconfig
      #   freeglut
      #   freetype
      #   gdk-pixbuf
      #   glew110
      #   libcaca
      #   libcanberra
      #   libdbusmenu-gtk2
      #   libgcrypt
      #   libidn
      #   libjpeg
      #   libmikmod
      #   libogg
      #   libpng
      #   libpng12
      #   librsvg
      #   libsamplerate
      #   libtheora
      #   libtiff
      #   libvdpau
      #   libvorbis
      #   libvpx
      #   pango
      #   pixman
      #   speex
      #   tbb
      #   SDL
      #   SDL2_image
      #   SDL2_mixer
      #   SDL2_ttf
      #   SDL_image
      #   SDL_mixer
      #   SDL_ttf
      #
      #   # Electron / Chromium dependencies
      #   libdrm
      #   mesa
      #   libxkbcommon
      # ];
    };
  };
}
