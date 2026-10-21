# Steam aspect
{ inputs, ... }:
{
  den.aspects.steam = {
    nixos = { ... }: {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
