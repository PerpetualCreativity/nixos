{ config, pkgs, ... }:

{
  imports = [
    ../home.nix
  ];

  home.packages = with pkgs; [
    box64

    firefox chromium
    # libreoffice-fresh
    inkscape

    errands newsflash
    armcord polari flare-signal fractal
    foliate tuba forge-sparks tex-match
    gnome-dictionary

    gnome-tweaks

    piper
  ] ++ (with gnomeExtensions; [
    just-perfection
    tailscale-qs
    caffeine
  ]);

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ "disabled" ];
      enabled-extensions = [
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "tailscale@joaophi.github.com"
        "syncthing-toggle@rehhouari.github.com"
      ];
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      speed = 0.4;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      clock-menu-position = 2;
      clock-menu-position-offset = 1;
      notification-banner-position = 2;
      window-demands-attention-focus = true;
    };
    chromium.commandLineArgs = [ "--user-agent=\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36\"" ];
  };
}
