# LAN PC — AMD Desktop
{ inputs, ... }:
{
  den.hosts."x86_64-linux".lan-pc = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.graceful = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.plymouth.enable = true;

    # -- Networking --
    networking.hostName = "lan-nix";
    networking.networkmanager.enable = true;

    hardware.amdgpu.initrd.enable = true;
    hardware.amdgpu.opencl.enable = true;

    services.hardware.openrgb.enable = true;
    hardware.i2c.enable = true;

    # -- Services --
    services = {
      printing.enable = true;
      libinput.enable = true;
      fstrim.enable = true;
      smartd = {
        enable = true;
        devices = [
          {
            device = "/dev/disk/by-uuid/7e796130-d691-48b7-acc4-adbb3dff940e";
          }
        ];
      };
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };

    security.rtkit.enable = true;
    xdg.portal.enable = true;

    # -- Nix settings --
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [ "electron-41.10.7" ];

    # -- Graphics drivers --
    hardware.graphics = {
      enable = true;
      extraPackages = with inputs.nixpkgs.legacyPackages."x86_64-linux"; [
        libvdpau-va-gl
        rocmPackages.clr.icd
      ];
      enable32Bit = true;
    };

    # -- Environment --
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # -- System-level packages --
    environment.systemPackages = with inputs.nixpkgs.legacyPackages."x86_64-linux"; [
      nvme-cli
    ];

    # -- Wait-online disabled --
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

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
