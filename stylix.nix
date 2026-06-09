{
  pkgs,
  ...
}: {
  # Enable stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-ocean.yaml";
}
