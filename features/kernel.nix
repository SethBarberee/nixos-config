{pkgs, ...}: {
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
}
