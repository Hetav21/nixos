{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  xorg,
  zlib,
  # Darwin dependencies
  unzip,
  makeWrapper,
  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",
  # Necessary for USB audio devices.
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  # For GPU acceleration support on Wayland (without the lib it doesn't seem to work)
  libGL,
  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder,VaapiVideoEncoder)
  libvaSupport ? stdenv.hostPlatform.isLinux,
  libva,
  enableVideoAcceleration ? libvaSupport,
  # For Vulkan support (--enable-features=Vulkan); disabled by default as it seems to break VA-API
  vulkanSupport ? false,
  addDriverRunpath,
  enableVulkan ? vulkanSupport,
}: {
  pname,
  version,
  hash,
  url,
}: let
  inherit
    (lib)
    optional
    optionals
    makeLibraryPath
    makeSearchPathOutput
    makeBinPath
    optionalString
    strings
    escapeShellArg
    ;

  deps =
    [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      gtk4
      libdrm
      libX11
      libGL
      libxkbcommon
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libxshmfence
      libXtst
      libuuid
      libgbm
      nspr
      nss
      pango
      pipewire
      udev
      wayland
      xorg.libxcb
      zlib
      snappy
      libkrb5
      qt6.qtbase
    ]
    ++ optional pulseSupport libpulseaudio
    ++ optional libvaSupport libva;

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  enableFeatures =
    optionals enableVideoAcceleration [
      "VaapiVideoDecoder"
      "VaapiVideoEncoder"
    ]
    ++ optional enableVulkan "Vulkan";

  disableFeatures =
    [
      "OutdatedBuildDetector"
    ] # disable automatic updates
    # The feature disable is needed for VAAPI to work correctly: https://github.com/brave/brave-browser/issues/20935
    ++ optionals enableVideoAcceleration ["UseChromeOSDirectVideoDecoder"];
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      inherit url hash;
    };

    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;
    doInstallCheck = stdenv.hostPlatform.isLinux;

    nativeBuildInputs =
      lib.optionals stdenv.hostPlatform.isLinux [
        dpkg
        # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
        # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
        (buildPackages.wrapGAppsHook3.override {makeWrapper = buildPackages.makeShellWrapper;})
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        unzip
        makeWrapper
      ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      # needed for GSETTINGS_SCHEMAS_PATH
      glib
      gsettings-desktop-schemas
      gtk3
      gtk4

      # needed for XDG_ICON_DIRS
      adwaita-icon-theme
    ];

    installPhase =
      lib.optionalString stdenv.hostPlatform.isLinux ''
        runHook preInstall

        mkdir -p $out $out/bin $out/usr/lib $out/usr/bin

        cp -R usr/share $out
        cp -R usr/lib/* $out/usr/lib/
        cp -R usr/bin/* $out/usr/bin/

        export BINARYWRAPPER=$out/usr/bin/browseros
        export ACTUALBINARY=$out/usr/lib/browseros/browseros

        # Fix paths in $BINARYWRAPPER (only if it's a text file)
        if file $BINARYWRAPPER | grep -q "text"; then
          substituteInPlace $BINARYWRAPPER \
              --replace-fail /bin/sh ${stdenv.shell} \
              --replace-fail /usr/lib/browseros $out/usr/lib/browseros
        fi

        # Copy the wrapper script to bin directory
        cp $BINARYWRAPPER $out/bin/browseros

        for exe in $out/usr/lib/browseros/{browseros,chrome_crashpad_handler}; do
            patchelf \
                --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath "${rpath}" $exe
        done

        # Fix paths
        if [ -d "$out/share/applications" ]; then
          for desktop in $out/share/applications/*.desktop; do
            if [ -f "$desktop" ]; then
              substituteInPlace "$desktop" --replace-fail /usr/bin/browseros $out/bin/browseros
            fi
          done
        fi

        # Icons are already in the correct location in the DEB package

        # Replace xdg-settings and xdg-mime
        ln -sf ${lib.getExe' xdg-utils "xdg-settings"} $out/usr/lib/browseros/xdg-settings
        ln -sf ${lib.getExe' xdg-utils "xdg-mime"} $out/usr/lib/browseros/xdg-mime

        runHook postInstall
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        runHook preInstall

        mkdir -p $out/{Applications,bin}

        cp -r . "$out/Applications/Brave Browser.app"

        makeWrapper "$out/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" $out/bin/brave

        runHook postInstall
      '';

    preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      # Add command line args to wrapGApp.
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${rpath}
        --prefix PATH : ${binpath}
        --suffix PATH : ${
        lib.makeBinPath [
          xdg-utils
          coreutils
        ]
      }
        ${optionalString (enableFeatures != []) ''
        --add-flags "--enable-features=${strings.concatStringsSep "," enableFeatures}\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations --enable-wayland-ime=true}}"
      ''}
        ${optionalString (disableFeatures != []) ''
        --add-flags "--disable-features=${strings.concatStringsSep "," disableFeatures}"
      ''}
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
        ${optionalString vulkanSupport ''
        --prefix XDG_DATA_DIRS  : "${addDriverRunpath.driverLink}/share"
      ''}
        --add-flags ${escapeShellArg commandLineArgs}
      )
    '';

    installCheckPhase = ''
      # Bypass upstream wrapper which suppresses errors
      $out/usr/lib/browseros/browseros --version
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      homepage = "https://www.browseros.com/";
      description = "The Open source agentic browser";
      changelog =
        "https://github.com/browseros-ai/BrowserOS/releases/tag/v"
        + version;
      longDescription = ''
        BrowserOS is an open source agentic browser that provides
        advanced automation and AI-powered browsing capabilities.
      '';
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [
        cawilliamson
      ];
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      mainProgram = "browseros";
    };
  }
