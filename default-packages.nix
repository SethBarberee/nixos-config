{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [ neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default. tree-sitter
    fastfetch
    wget
    kitty
    git

    # Sound utilities
    pavucontrol
    qpwgraph
    alsa-firmware
    alsa-utils
    sof-firmware

    # Graphics stuff
    mesa-demos
    clinfo

    # Nix dev/lsp
    nixd
    alejandra

    # Media/extra things
    zoom-us
    steam
    lutris
    openrct2
    nyancat
    spotify
    jellyfin-desktop
    webcord
    osu-lazer-bin
    mgba
    melonds

    # Install extra KDE apps
    kdePackages.plasma-thunderbolt
    kdePackages.kcalc
    kdePackages.ksystemlog
    kdePackages.sddm-kcm

    hardinfo2
    lm_sensors
    wayland-utils
    wl-clipboard
    usbutils
    btop
    stow
    cpu-x

    google-chrome

    # keyboard dev
    qmk
    via
    dos2unix

    compiledb
    xsensors
  ];
}
