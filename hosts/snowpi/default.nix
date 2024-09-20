{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../shared
    ../../shared/unify.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "snowpi";
  };
  networking.firewall.allowedUDPPorts = [ 41641 ];

  services.syncthing.guiAddress = "0.0.0.0:8384";
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.11";
}
