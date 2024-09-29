{
  config,
  pkgs,
  ...
}@inputs:
{
  imports = [
    ./..
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "bredr";
    };
  };
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
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
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

  fonts.packages = with pkgs; [
    inter
    iosevka
    victor-mono
    twemoji-color-font
    crimson-pro
    pixel-code
  ];
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [ wireshark ];
}
