# Stylix aspect — color scheme for both nixos and home-manager
{ inputs, pkgs, ... }:
{
  den.aspects.stylix = {
    nixos = { inputs, pkgs, ... }: {
      stylix.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-ocean.yaml";
    };
    homeManager = { ... }: {
      stylix.targets.firefox.profileNames = [ "sethb" ];
      stylix.targets.neovim.enable = false;
    };
  };
}
