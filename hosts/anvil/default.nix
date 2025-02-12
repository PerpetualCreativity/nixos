{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../shared
  ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.11";
}
