{ config, pkgs, ... }:
{
  imports = [
    ./..
    ./fonts.nix
  ];
  hardware.bluetooth.enable = true;
  
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
  };
  services.printing.enable = true;
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.ratbagd.enable = true;

}
