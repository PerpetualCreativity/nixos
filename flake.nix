{
  description = "all of my nixos configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
    };
    widevine-aarch64 = {
      url = "github:epetousis/nixos-aarch64-widevine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      apple-silicon,
      nixos-hardware,
      nix-index-database,
      ...
    }@inputs:
    let
      # https://discourse.nixos.org/t/51146
      standard =
        nixosConfig: homeConfig: hostModules: hostConfig:
        [
          { _module.args.inputs = inputs; }
          nixosConfig
          ./shared/options.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.vulcan = import homeConfig;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
          nix-index-database.nixosModules.nix-index
        ]
        ++ hostModules
        ++ [ hostConfig ];
    in
    {
      nixosConfigurations = {
        forge = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit apple-silicon;
          };
          modules = standard ./hosts/forge ./shared/desktop/home.nix [ ] {
            local.desktop.swap_caps_and_esc = true;
            nixpkgs.overlays = [ inputs.widevine-aarch64.overlays.default ];
            virtualisation.docker.enable = true;
            users.users.vulcan.extraGroups = [ "docker" ];
          };
        };
        snowpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = standard ./hosts/snowpi ./shared/home.nix [ ./shared/site-mon.nix ] {
            documentation.man.generateCaches = false;
            services.miniflux = {
              enable = true;
              adminCredentialsFile = "/home/vulcan/.miniflux_conf";
              config.PORT = "8380";
            };
          };
        };
        foundry = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            standard ./hosts/foundry ./shared/desktop/home.nix
              [
                nixos-hardware.nixosModules.apple-t2
              ]
              {
                local.desktop.ghostty = true;
                virtualisation.virtualbox.host.enable = true;
                virtualisation.docker.enable = true;
                users.users.vulcan.extraGroups = [ "docker" ];
                #dconf.settings."org/gnome/shell/extensions/just-perfection".panel = false;
              };
        };
        anvil = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = standard ./hosts/anvil ./shared/home.nix [ ] { };
        };
      };

      formatter = nixpkgs.lib.attrsets.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ] (system: (import nixpkgs { inherit system; }).nixfmt-rfc-style);
    };

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
}
