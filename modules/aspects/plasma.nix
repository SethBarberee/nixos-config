# Plasma Desktop Environment aspect
{ inputs, ... }:
{
  den.aspects.plasma = {
    nixos = { ... }: {
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
    };
  };
}
