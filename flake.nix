{
  description = "nixos config — den aspect-oriented";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den = {
      url = "github:denful/den";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree = {
      url = "github:denful/import-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      den =
        (inputs.nixpkgs.lib.evalModules {
          modules = [
            (inputs.import-tree ./modules)
          ];
          specialArgs = { inherit inputs; };
        }).config;
    in
    {
      # Inherit all flake-compatible outputs from den
      inherit (den.flake) nixosConfigurations darwinConfigurations;

      # Each host re-wraps with stylix, NUR, and home-manager
      nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nur.modules.nixos.default
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          den.hosts."x86_64-linux".default.mainModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sethb = import ./home.nix;
            };
          }
        ];
      };

      nixosConfigurations.lan-pc = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nur.modules.nixos.default
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          den.hosts."x86_64-linux".lan-pc.mainModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sethb = import ./home.nix;
            };
          }
        ];
      };
    };
}
