# Firefox aspect — home-manager only
{ inputs, pkgs, ... }:
{
  den.aspects.firefox = {
    homeManager =
      {
        inputs,
        pkgs,
        config,
        lib,
        ...
      }:
      {
        programs.firefox = {
          enable = true;
          configPath = "${config.xdg.configHome}/mozilla/firefox";

          policies = {
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisableFirefoxAccounts = true;
            DisableFirefoxScreenshots = true;
            DisableSetDesktopBackground = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
          };

          profiles = {
            sethb = {
              id = 0;
              name = "sethb";
              isDefault = true;
              settings = {
                "browser.startup.homepage" = "https://sethbarberee.github.io/Galaxy";
                "widget.use-xdg-desktop-portal.file-picker" = 1;
              };
              extensions.packages = with inputs.nur.repos.rycee.firefox-addons; [
                bitwarden
                ublock-origin
                darkreader
              ];
              search = {
                force = true;
                default = "ddg";
                privateDefault = "ddg";
              };
            };
          };
        };
      };
  };
}
