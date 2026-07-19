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

    # Nix-Darwin for macOS. Now following our nixpkgs — if internal builds break
    # (darwin-manual-html etc.), remove the follows and re-enable workarounds in
    # hosts/mac/default.nix. System packages use nixpkgs.pkgs = pkgsMac below.
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nixos-wsl,
      nix-homebrew,
      git-hooks,
      ...
    }@inputs:
    let
      # Systems
      systemWSL = "x86_64-linux";
      systemMac = "aarch64-darwin";

      systems = [
        systemWSL
        systemMac
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsMac = import nixpkgs {
        system = systemMac;
        config.allowUnfree = true;
      };

    in
    {
      # NixOS configurations (WSL)
      nixosConfigurations = {
        nixos-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
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
          specialArgs = { inherit inputs; };
          modules = [
            # Use our nixpkgs for user-facing packages; nix-darwin's own
            # pinned nixpkgs handles its internal builds (see input above).
            { nixpkgs.pkgs = pkgsMac; }

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

      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "nixfmt-wrapper";
          runtimeInputs = [
            pkgs.nixfmt
            pkgs.findutils
          ];
          text = ''
            find "$@" -type f -name "*.nix" -exec nixfmt {} +
          '';
        }
      );

      checks = forAllSystems (system: {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            deadnix = {
              enable = true;
              settings.noLambdaArg = true;
              settings.noLambdaPatternNames = true;
            };
            shellcheck.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit) shellHook;
          buildInputs = self.checks.${system}.pre-commit.enabledPackages;
        };
      });
    };
}
