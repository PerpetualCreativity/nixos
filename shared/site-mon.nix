{ pkgs, ... }:
{
  systemd.services.site-mon = {
    serviceConfig.Type = "oneshot";
    path = [ pkgs.fish ];
    script = ''fish /home/vulcan/nixos/bin/site-mon'';
    startAt = "daily";
  };
  systemd.timers.site-mon.timerConfig.Persistent = true;
}
