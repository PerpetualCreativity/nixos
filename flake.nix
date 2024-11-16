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
      # inputs.nixpkgs.follows = "nixpkgs";
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
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
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
          { _module.args = inputs; }
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
          };
        };
        snowpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = standard ./hosts/snowpi ./shared/home.nix [ ./shared/site-mon.nix ] {
            documentation.man.generateCaches = false;
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
                environment.systemPackages = [
                  inputs.ghostty.packages.x86_64-linux.default
                ];
              };
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
      "https://ghostty.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };
}
