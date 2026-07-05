{
  description = "Cross-platform Nix configuration for NixOS-WSL and macOS";

  inputs = {
    # Core packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Darwin for macOS
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-homebrew for managing Homebrew from nix-darwin
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, nixos-wsl, nix-homebrew, ... }@inputs:
    let
      # Systems
      systemWSL = "x86_64-linux";
      systemMac = "aarch64-darwin";

      # Define Nixpkgs for each system
      pkgsWSL = import nixpkgs {
        system = systemWSL;
        config.allowUnfree = true;
      };

      pkgsMac = import nixpkgs {
        system = systemMac;
        config.allowUnfree = true;
      };

    in {
      # NixOS configurations (WSL)
      nixosConfigurations = {
        nixos-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgsWSL; };
          modules = [
            { nixpkgs.hostPlatform = systemWSL; }
            nixos-wsl.nixosModules.default
            ./hosts/wsl/configuration.nix
            
            # Home Manager integrated module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.nixos = import ./home/wsl.nix;
            }
          ];
        };
      };

      # nix-darwin configurations (macOS)
      darwinConfigurations = {
        macbook = nix-darwin.lib.darwinSystem {
          system = systemMac;
          specialArgs = { inherit inputs pkgsMac; };
          modules = [
            ./hosts/mac/default.nix

            # nix-homebrew: adopt the existing /opt/homebrew
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = "rauls.kjarners";
                autoMigrate = true;
                mutableTaps = true;
              };
            }

            # Home Manager integrated module
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "pre-nix-bak";
              home-manager.users."rauls.kjarners" = import ./home/mac.nix;
            }
          ];
        };
      };
    };
}
