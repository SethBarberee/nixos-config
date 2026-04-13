{
  config,
  ...
}: {
  # Enable firefox
  programs.firefox = {
    enable = true;
    preferences = {
      "browser.startup.homepage" = "https://sethbarberee.github.io/Galaxy";
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };

    policies = {
      DisablePocket = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableSetDesktopBackground = true;

      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url       = moz "ublock-origin";
          installation_mode = "force_installed";
          updates_disabled = true;
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url       = moz "darkreader";
          installation_mode = "force_installed";
          updates_disabled = true;
        };
      };
    };
  };
}
