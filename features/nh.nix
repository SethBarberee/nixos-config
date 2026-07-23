{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 14d";
    clean.dates = "weekly";
    flake = "/home/sethb/nixos-config";
  };
}
