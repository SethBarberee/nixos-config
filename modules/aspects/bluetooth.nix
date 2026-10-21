# Bluetooth aspect
{ inputs, ... }:
{
  den.aspects.bluetooth = {
    nixos = { ... }: {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General.Experimental = true;
          Policy.AutoEnable = true;
        };
      };
    };
  };
}
