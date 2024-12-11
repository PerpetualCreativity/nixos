{ lib, ... }:
with lib;
{
  options.local.desktop.swap_caps_and_esc = mkOption {
    description = lib.mdDoc "whether to swap caps and esc on desktops";
    default = false;
    example = true;
    type = lib.types.bool;
  };
  options.local.desktop.ghostty = mkOption {
    description = lib.mdDoc "whether to install ghostty on a desktop";
    default = false;
    example = true;
    type = lib.types.bool;
  };
}
