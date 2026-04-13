{
  config,
  ...
}: {
 
 # Enable tailscale and firewall
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
    checkReversePath = "loose";
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL=nftables"
  ];
}
