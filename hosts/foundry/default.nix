{ config, lib, pkgs }:
{
  imports = [
    ../../shared/desktop
    ../../shared/unify.nix
    ./hardware-configuration.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
  networking.hostName = "foundry";

  system.stateVersion = "24.11";
}
