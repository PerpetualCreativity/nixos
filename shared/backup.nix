{ pkgs, lib, services, name, hostname }:
{
  # list snapshots with `doas restic-$USER snapshots`
  # restore snapshots with `doas restic-$USER restore --target restore-backup latest`
  services.restic.backups = {
    ${name} = {
      user = "${name}";
      repository = "s3:https://[account id].r2.cloudflarestorage.com/${name}-${hostname}";
      passwordFile = lib.mkDefault "";
      environmentFile = lib.mkDefault "";
      paths = lib.mkDefault [
        "/home/${name}/nixos"
        "/home/${name}/gt"
        "/home/${name}/projects"
        "/home/${name}/notes"
      ];
      initialize = true;
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
      timerConfig = {
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
  # FIXME
  environment.systemPackages = with pkgs; [ libnotify ];
  systemd.services.restic-backups-user.unitConfig.OnFailure = "notify-when-backup-fails.service";
  systemd.services.notify-when-backup-fails.script = ''
    notify-send 'backup failed!' \
      --app-name restic-backup-${name} \
      --urgency critical
  '';
}
