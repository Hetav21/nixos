{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  username = "hetav";
  userDescription = "Hetav Shah";
  homeDirectory = "/home/${username}";
  hostName = "nixbook";
  timeZone = "Asia/Kolkata";
  wallpaper = "artistic-boy-relaxing.jpg";
in {
  nixpkgs.config.allowUnfree = true;
  ## nixpkgs.config.allowBroken = true;
  ## nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "SDL_ttf-2.0.11"
  ];

  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../modules/modules-imports.nix
    ../../systemd/systemd-extra-imports.nix
    ../../lib/lib-imports.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelModules = ["xe"];
    kernelModules = ["v4l2loopback" "xe"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    blacklistedKernelModules = ["i915"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      ##      enable = false; ## Disable firewall
      allowedTCPPortRanges = [
        {
          from = 8060;
          to = 8090;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 8060;
          to = 8090;
        }
      ];
    };
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../config/assets/${wallpaper};
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    waydroid.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
    };

    localsend = {
      enable = true;
      openFirewall = true;
    };

    firefox.enable = false;

    dconf.enable = true;

    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    rog-control-center = {
      enable = true;
      autoStart = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = ["networkmanager" "mlocate" "wheel"];
      packages = with pkgs; [
        firefox
        thunderbird
      ];
    };
  };

  # Nix-Flatpak
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    packages = [
      "org.texstudio.TeXstudio"
      "com.todoist.Todoist"
      "com.spotify.Client"
      "org.gnome.Loupe"
      "com.microsoft.Edge"
      "com.github.IsmaelMartinez.teams_for_linux"
      "org.libreoffice.LibreOffice"
      "com.github.tchx84.Flatseal"
      "com.stremio.Stremio"
      "com.calibre_ebook.calibre"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    ##    neovim
    ##    neovide
    vscode
    vim
    sublime4
    zed-editor_git
    jetbrains.idea-ultimate

    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    # Programming languages and tools
    go
    lua
    python3
    python3Packages.pip
    uv
    clang
    zig
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    bun
    jdk
    maven
    gcc

    # Frappe Bench
    redis
    wkhtmltopdf
    nginx
    uv
    mariadb
    mongodb-compass

    # Version control and development tools
    ## bruno
    git
    gh
    lazygit
    lazydocker
    gnumake
    coreutils
    nixfmt-rfc-style
    meson
    ninja
    distrobox
    devenv
    open-webui

    # Shell and terminal utilities
    ##    inputs.nixCats.packages.${pkgs.system}.nixCats
    alejandra
    stow
    tmux
    wget
    pandoc
    killall
    eza
    starship
    kitty
    zoxide
    fzf
    tmux
    progress
    tree
    alacritty
    nix-index

    # File management and archives
    yazi
    p7zip
    unzip
    unrar
    file-roller
    ncdu
    duf
    zip

    # System monitoring and management
    htop
    btop
    lm_sensors
    inxi
    auto-cpufreq
    nix-output-monitor

    # Network and internet tools
    onedrive
    cloudflare-warp
    aria2
    qbittorrent
    tailscale
    rclone
    megasync
    megacmd

    # Audio and video
    pulseaudio
    alsa-utils
    pavucontrol
    ffmpeg
    mpv
    deadbeef-with-plugins
    obs-studio

    # Image and graphics
    gimp
    loupe
    imagemagick
    hyprpicker
    swww
    waypaper
    imv

    # Productivity and office
    spacedrive
    hugo
    ## obsidian
    onlyoffice-bin
    hplip

    # Communication and social
    telegram-desktop
    element-desktop
    zoom-us
    discord
    vesktop

    # Browsers
    firefox
    brave

    # Gaming and entertainment
    ##    stremio

    # System utilities
    libgcc
    bc
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    yad
    playerctl
    nh
    ansible
    kdePackages.kwallet

    # Wayland specific
    hyprshot
    grim
    slurp
    waybar
    dunst
    wl-clipboard
    swaynotificationcenter

    # Virtualization
    libvirt

    # File systems
    ntfs3g

    # Downloaders
    yt-dlp
    localsend

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet

    # Education
    ## ciscoPacketTracer8
    wireshark
    ventoy

    # Music and streaming
    #    spotify
    youtube-music
    spicetify-cli

    # Miscellaneous
    libsForQt5.qt5.qtgraphicaleffects # sddm dep
  ];

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
    fira-code
  ];

  xdg.portal = {
    enable = true;

    wlr.enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];

    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };

    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = ["modesetting"];
    };

    pulseaudio.enable = false;

    displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true; # Enable SDDM.
        wayland.enable = true;
        autoNumlock = true;
        sugarCandyNix = {
          enable = true; # This set SDDM's theme to "sddm-sugar-candy-nix".
          settings = {
            # Set your configuration options here.
            # Here is a simple example:
            Background = lib.cleanSource ../../config/assets/${wallpaper};
            ScreenWidth = 1920;
            ScreenHeight = 1080;
            FormPosition = "left";
            HaveFormBackground = true;
            PartialBlur = true;
          };
        };
      };
    };

    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };

    cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };

    supergfxd.enable = true;

    asusd = {
      enable = true;
      enableUserService = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    open-webui = {
      enable = true;
      openFirewall = true;
    };

    cron = {
      enable = true;
    };

    libinput.enable = true;

    fstrim.enable = true;

    gvfs.enable = true;

    openssh.enable = true;

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin]; # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
    };
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    gnome.gnome-keyring.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ipp-usb.enable = true;

    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  systemd = {
    targets = {
      sleep = {
        enable = true;
        unitConfig.DefaultDependencies = "yes";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };

    services = {
      ###  To disable a systemd service:
      ##   <service-name>.wantedBy = lib.mkForce [ ];
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  drivers = {
    intel.enable = true;
    nvidia.enable = true;
    nvidia-prime.enable = true;
  };

  systemd.extra = {
    rclone.enable = true;
    muteMicrophone.enable = true;
    mega-sync.enable = true;
  };

  services.blueman.enable = true;

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      trusted-users = ["root" "${username}"];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      stalled-download-timeout = 99999999;
      max-jobs = 2;
      cores = 8;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.11";
}
