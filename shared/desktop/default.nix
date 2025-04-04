{
  config,
  pkgs,
  lib,
  ghostty,
  inputs,
  ...
}:
{
  imports = [
    ./..
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.ControllerMode = "bredr";
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap,avrcp"
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
  };
  environment.gnome.excludePackages = with pkgs; [
    yelp
    evince
    gnome-tour
    gnome-clocks
  ];

  services.printing = {
    enable = true;
    # drivers = [ pkgs.hplipWithPlugin ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.ratbagd.enable = true;
  hardware.keyboard.zsa.enable = true;

  documentation.man.generateCaches = true;

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [ swaylock ])
    (lib.mkIf config.local.desktop.ghostty [ pkgs.ghostty ])
  ];
}
