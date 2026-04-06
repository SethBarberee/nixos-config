# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NOTE: Disable loading this driver and fall back to snd_hda_intel.
  # Otherwise, there is a race condition between the two drivers.
  boot.blacklistedKernelModules = ["snd_soc_avs"];

  # Add splash screen for boot
  boot.plymouth.enable = true;

  # Use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Area to configure module params
  # boot.extraModprobeConfig = ''

  # '';

  boot.kernelParams = [
    "quiet"
    "splash"
    "usbcore.autosuspend=120" # wait two minutes (120 seconds) before suspend
  ];

  # Set up networking
  networking = {
    hostName = "nixos";
    wireless = {
      iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = true;
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services = {
    printing.enable = true;
    libinput.enable = true;

    # Enable trim
    fstrim.enable = true;

    # Enable thermald
    thermald.enable = true;

    hardware.bolt.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable sound via pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  # For screensharing
  xdg.portal = {
    enable = true;
    #extraPortals = with pkgs; [
    #	xdg-desktop-portal-kde
    #];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sethb = {
    isNormalUser = true;
    description = "Seth Barberee";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      vlc
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add VA-API driver
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      rocmPackages.clr.icd
    ];
    enable32Bit = true;
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Enable blutooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        # FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    fastfetch
    wget
    kitty
    git

    # Sound utilities
    pavucontrol
    qpwgraph

    # Graphics stuff
    mesa-demos
    clinfo

    # Nix dev/lsp
    nixd
    alejandra

    # python dev
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        pandas
        requests
        python-lsp-server
        python-lsp-jsonrpc
        isort
      ]))

    # Media/extra things
    zoom-us
    steam
    spotify

    # Install extra KDE apps
    kdePackages.plasma-thunderbolt
    kdePackages.kcalc
    kdePackages.ksystemlog
    kdePackages.sddm-kcm

    hardinfo2
    wayland-utils
    wl-clipboard
    powertop
    usbutils

  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # Enable firefox
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
    };
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  # Enable tailscale and firewall
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose";
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
   "TS_DEBUG_FIREWALL=nftables"
   ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Enable NixOs Power Management
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  # Enable automatic garbage collection
  nix.gc.automatic = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";


  # Enable stylix
  stylix.enable = true;
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.base16Scheme = {
    base00 = "#1e1c31"; # background
    base01 = "#565575"; # alternate background
    base02 = "#cbe3e7"; 
    base03 = "#100e23"; # unfocused window border
    base04 = "#cbe3e7"; 
    base05 = "#cbe3e7"; # text
    base06 = "#cbe3e7"; 
    base07 = "#cbe3e7"; 
    base08 = "#ff5458"; # urgent window border
    base09 = "#62d196"; 
    base0A = "#ffb378"; # warning
    base0B = "#65b2ff"; 
    base0C = "#906cff"; 
    base0D = "#63f2f1"; # focused window border
    base0E = "#c991e1"; 
    base0F = "#ffe9aa"; 
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
