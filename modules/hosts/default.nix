# Default host — Dell XPS 9575 2-in-1 Laptop
{ inputs, ... }:
{
  den.hosts."x86_64-linux".default = {
    # -- Bootloader --
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.graceful = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.plymouth.enable = true;

    # -- Networking --
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    # -- Services --
    services = {
      printing.enable = true;
      libinput.enable = true;
      fstrim.enable = true;
      thermald.enable = true;
      smartd = {
        enable = true;
        devices = [
          {
            device = "/dev/disk/by-id/nvme-KXG60ZNV512G_NVMe_TOSHIBA_512GB_Y8MA23CCK04N";
          }
        ];
      };
      hardware.bolt.enable = true;
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };

    security.rtkit.enable = true;
    xdg.portal.enable = true;

    # -- Nix settings --
    nixpkgs.config.allowUnfree = true;

    # -- Graphics drivers --
    hardware.graphics = {
      enable = true;
      extraPackages = with inputs.nixpkgs.legacyPackages."x86_64-linux"; [
        intel-media-driver
        libvdpau-va-gl
        rocmPackages.clr.icd
      ];
      enable32Bit = true;
    };

    # -- Environment --
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # -- System-level packages --
    environment.systemPackages = with inputs.nixpkgs.legacyPackages."x86_64-linux"; [
      powertop
    ];

    # -- Extra KDE apps (system profile) --
    environment.systemPackages = with inputs.nixpkgs.legacyPackages."x86_64-linux"; [
      kdePackages.plasma-thunderbolt
      kdePackages.kcalc
      kdePackages.ksystemlog
      kdePackages.sddm-kcm
    ];

    # -- Wait-online disabled --
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    # -- Power management --
    powerManagement.enable = true;
    powerManagement.powertop.enable = true;

    # -- Flakes --
    nix.settings.experimental-features = "nix-command flakes";
    system.stateVersion = "25.11";

    # -- User --
    den.users.sethb = { };

    # -- Selected aspects --
    den.aspects-selection = [
      "audio"
      "bluetooth"
      "kernel"
      "locale"
      "plasma"
      "steam"
      "tailscale"
      "stylix"
      "nh"
      "qmk"
      "user"
      "neovim"
      "firefox"
      "mangohud"
    ];
  };
}
