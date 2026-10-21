# Keyboard controller (qmk) aspect
{ inputs, pkgs, ... }:
{
  den.aspects.qmk = {
    nixos = { ... }: {
      hardware.keyboard.qmk.enable = true;
      services.udev.packages = [
        pkgs.via
        pkgs.qmk-udev-rules
      ];
    };
  };
}
