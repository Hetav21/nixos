{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.nix.ld";
  hasGui = false;
  cliConfig = {
    # --- Nix-LD Dynamic Linker Support ---
    programs.nix-ld = {
      enable = true;

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
