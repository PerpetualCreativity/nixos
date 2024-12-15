{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.config
    inputs.anyrun.homeManagerModules.default
  ];
  programs.niri = {
    package = pkgs.niri;
    settings = {
      debug.render-drm-device = "/dev/dri/renderD128"; # asahi specific
      input = {
        keyboard.xkb.options = "caps:swapescape";
        touchpad = {
          tap = false;
          dwt = true;
        };
      };
      layout.focus-ring = {
        width = 5;
      };
      window-rules = [
        {
          geometry-corner-radius =
          let r = 8.0; in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
          clip-to-geometry = true;
        }
      ];
      binds = with config.lib.niri.actions; {
        "Super+Shift+Slash".action = show-hotkey-overlay;
        "Super+T".action = spawn "ptyxis";
        "Super+Space".action = spawn "anyrun";
        "Super+Q".action = close-window;

        "Super+H".action = focus-column-left;
        "Super+J".action = focus-window-down;
        "Super+K".action = focus-window-up;
        "Super+L".action = focus-column-right;
        "Super+Alt+H".action = move-column-left;
        "Super+Alt+J".action = move-window-down;
        "Super+Alt+K".action = move-window-up;
        "Super+Alt+L".action = move-column-right;

        "Super+Shift+H".action = focus-monitor-left;
        "Super+Shift+J".action = focus-monitor-down;
        "Super+Shift+K".action = focus-monitor-up;
        "Super+Shift+L".action = focus-monitor-right;

        "Super+U".action = focus-workspace-down;
        "Super+I".action = focus-workspace-up;
        "Super+Shift+U".action = move-workspace-down;
        "Super+Shift+I".action = move-workspace-up;

        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
        # "XF86MonBrightnessUp".action = spawn;
        # "XF86MonBrightnessDown".action = spawn;
      };
    };
  };
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
    };
  };
}
