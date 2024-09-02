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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    widevine-aarch64 = {
      url = "github:epetousis/nixos-aarch64-widevine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  {
    self, nixpkgs, home-manager,
    apple-silicon, nixos-hardware,
    nix-index-database,
    ...
  }@inputs:
  let
    # https://discourse.nixos.org/t/51146
    standard = nixosConfig: homeConfig: [
      nixosConfig
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.vulcan = import homeConfig;
      }
      nix-index-database.nixosModules.nix-index
    ];
  in
  {
    nixosConfigurations = {
      forge = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit apple-silicon; };
        modules = standard ./hosts/forge ./shared/desktop/home.nix ++ [
          { nixpkgs.overlays = [ inputs.widevine-aarch64.overlays.default ]; }
        ];
      };
      snowpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = standard ./hosts/snowpi ./shared/home.nix;
      };
      foundry = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = standard ./hosts/foundry ./shared/desktop/home.nix ++ [
          # ./hosts/foundry/substituter.nix
          nixos-hardware.nixosModules.apple-t2
        ];
      };
    };
  };

  nixConfig = {
    extra-substituters = [ "https://cache.soopy.moe" ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
  };
}
