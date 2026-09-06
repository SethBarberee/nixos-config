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
    ./default-packages.nix
    ./features/audio.nix
    ./features/bluetooth.nix
    ./features/kernel.nix
    ./features/locale.nix
    ./features/plasma.nix
    ./features/steam.nix
    ./features/tailscale.nix
    ./features/sethb.nix
    ./features/stylix.nix
    ./features/nh.nix
    ./features/qmk.nix
    ./lan-hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add splash screen for boot
  boot.plymouth.enable = true;

  hardware.amdgpu.initrd.enable = true; # load amdgpu during Stage 1
  hardware.amdgpu.opencl.enable = true; # load amdgpu during Stage 1

  # Set up networking
  networking = {
    hostName = "lan-nix";
    networkmanager.enable = true;
  };

  services.hardware.openrgb.enable = true;
  hardware.i2c.enable = true;

  services = {
    printing.enable = true;
    libinput.enable = true;

    # Enable trim
    fstrim.enable = true;

    # Enable smartd
    smartd = {
      enable = true;
      devices = [
        {
          device = "/dev/disk/by-uuid/7e796130-d691-48b7-acc4-adbb3dff940e"; 
        }
      ];
    };

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
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
      #intel-media-driver
      libvdpau-va-gl
      rocmPackages.clr.icd
    ];
    enable32Bit = true;
  };

  #environment.sessionVariables = {
  #  LIBVA_DRIVER_NAME = "iHD";
  #  VDPAU_DRIVER = "va_gl";
  #};

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nvme-cli 
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
