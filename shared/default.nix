{
  config,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      extra-platforms = config.boot.binfmt.emulatedSystems;
      trusted-users = [
        "root"
        "vulcan"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "vulcan" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  users.users.vulcan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    helix
    curl
    wget
    strace
    ltrace
    doas-sudo-shim # to support --use-remote-sudo
  ];
  programs.fish.enable = true;
}
