{ config, pkgs, ... }:
{
  imports = [ ./.. ];
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

  # nixpkgs.config = {
  #   packageOverrides = super: let self = super.pkgs; in {
  #   };
  # };

  # environment.systemPackages = with pkgs; [
  #   iosevka-term
  # ];
}
