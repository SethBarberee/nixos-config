# Kernel aspect — Zen kernel with autosuspend
{ inputs, ... }:
{
  den.aspects.kernel = {
    nixos = { pkgs, ... }: {
      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.kernelParams = [
        "quiet"
        "splash"
        "usbcore.autosuspend=120"
      ];
    };
  };
}
