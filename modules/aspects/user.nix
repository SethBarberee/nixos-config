# User account — defines sethb on nixos
# Uses den batteries for cross-platform user definition.
{ inputs, pkgs, ... }:
{
  den.aspects.user = {
    nixos = { ... }: {
      users.users.sethb = {
        isNormalUser = true;
        description = "Seth Barberee";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          vlc
        ];
      };
    };
  };
}
