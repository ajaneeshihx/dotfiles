{
  description = "My system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager }:
    let
      # Set the system type globally (changeme)
      system = "x86_64-linux";

      # Gather the Nix packages
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      user = "noah";
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = [
                    ./nixos/home.nix
                    ./modules/applications/firefox.nix
                    ./modules/shell/fish.nix
                    ./modules/shell/utilities.nix
                    ./modules/shell/git.nix
                    ./modules/shell/github.nix
                    ./modules/editor/neovim.nix
                    ./modules/applications/alacritty.nix
                  ];
                };
              };
            }
          ];
        };
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [ stylua nixfmt shfmt shellcheck ];
      };

    };
}
