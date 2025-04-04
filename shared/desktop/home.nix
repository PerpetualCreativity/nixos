{
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../home.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
// lib.mkMerge [
  {
    home.packages =
      with pkgs;
      [
        xsel
        wl-clipboard

        # libreoffice-fresh
        inkscape

        ptyxis
        papers
        easyeffects
        newsflash
        legcord
        polari
        flare-signal
        fractal
        foliate
        tuba
        hieroglyphic
        wordbook
        turtle

        gnome-tweaks

        piper

        # fonts
        inter
        iosevka
        victor-mono
        twemoji-color-font
        crimson-pro
        pixel-code
        atkinson-hyperlegible

        # man pages
        linux-manual
        man-pages
        man-pages-posix
        signal-desktop
      ]
      ++ (with gnomeExtensions; [
        just-perfection
        tailscale-qs
        caffeine
        tiling-shell
        blur-my-shell
      ]);
    fonts.fontconfig.enable = true;

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
          "caffeine@patapon.info"
        ];
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
        speed = 0.4;
      };

      "org/gnome/desktop/input-sources" = lib.mkIf osConfig.local.desktop.swap_caps_and_esc {
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
    };
    home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
    programs.firefox = {
      enable = true;
      profiles.default = {
        name = "Default";
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "browser.uidensity" = 0;
          # "browser.theme.dark-private-windows" = false;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
        };
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
          /* @import "firefox-gnome-theme/theme/colors/dark.css"; */
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
      };
    };
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--user-agent=\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36\""
      ];
    };
    # programs.spicetify =
    #   let
    #     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    #   in
    #   {
    #     enable = true;
    #     enabledExtensions = with spicePkgs.extensions; [
    #       adblock
    #       hidePodcasts
    #     ];
    #     theme = spicePkgs.themes.ziro;
    #     colorScheme = "rose-pine-moon";
    #   };
  }
  (lib.mkIf osConfig.local.desktop.ghostty {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        font-family = "Iosevka";
        theme = "rose-pine-moon";
      };
    };
  })
]
