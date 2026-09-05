{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5";
    clean.dates = "weekly";
    flake = "/home/sethb/nixos-config";
  };
}
