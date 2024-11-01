{
  config,
  pkgs,
  ...
}:
{
  services.tailscale.enable = true;
  services.syncthing = {
    enable = true;
    user = "vulcan";
    dataDir = "/home/vulcan";
    configDir = "/home/vulcan/.config/syncthing";
    openDefaultPorts = true;
  };
  systemd.services.tailscaled.after = [ "NetworkManager-wait-online.service" ];
}
