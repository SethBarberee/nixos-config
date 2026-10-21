# Tailscale aspect
{ inputs, ... }:
{
  den.aspects.tailscale = {
    nixos = { ... }: {
      services.tailscale.enable = true;
      services.tailscale.useRoutingFeatures = "client";
      networking.nftables.enable = true;
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ 8083 ];
        checkReversePath = "loose";
      };
      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL=nftables"
      ];
    };
  };
}
