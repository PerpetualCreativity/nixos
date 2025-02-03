{
  config,
  lib,
  pkgs,
  apple-silicon,
  ...
}:
{
  imports = [
    ../../shared/desktop
    ../../shared/unify.nix
    ./hardware-configuration.nix
    apple-silicon.nixosModules.apple-silicon-support
  ];

  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
  };
  boot = {
    binfmt = {
      emulatedSystems = [ "x86_64-linux" ];
      # registrations.x86_64-linux.interpreter = "${pkgs.box64}/bin/box64";
    };
    kernelParams = [ "apple_dcp.show_notch=1" ];
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = false;
      timeout = 1;
    };
  };
  networking = {
    hostName = "forge";
    # nameservers = [ "1.1.1.1" "9.9.9.9" ];
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        # General.EnableNetworkConfiguration = true;
      };
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  zramSwap = {
    enable = true;
    priority = 5;
  };

  # environment.systemPackages = with pkgs; [ box64 ];

  # widevine support for firefox
  environment.sessionVariables.MOX_GMP_PATH = [
    "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"
  ];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
