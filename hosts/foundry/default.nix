{
  config,
  lib,
  pkgs,
  ...
}:
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
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./firmware/brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.hostName = "foundry";

  system.stateVersion = "24.11";
}
