{ pkgs, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      WEB_VAULT_FOLDER = "${pkgs.vaultwarden}";
      WEB_VAULT_ENABLED = true;
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "0.0.0.0";
      WEBSOCKET_PORT = 3012;
      SIGNUPS_VERIFY = true;
      DOMAIN = ""; # TODO FIXME
    };
  };
}
