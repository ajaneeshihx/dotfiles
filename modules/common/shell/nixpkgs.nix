{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.users.${config.user} = {

    programs.fish = {
      shellAbbrs = {
        n = "nix";
        ns = "nix-shell -p";
        nsf = "nix-shell --run fish -p";
        nsr = "nix-shell-run";
        nps = "nix repl --expr 'import <nixpkgs>{}'";
        nixo = "man configuration.nix";
        nixh = "man home-configuration.nix";
        nr = {
          function = "rebuild-nixos";
        };
        nro = {
          function = "rebuild-nixos-offline";
        };
        hm = {
          function = "rebuild-home";
        };
      };
      functions = {
        nix-shell-run = {
          body = ''
            set program $argv[1]
            if test (count $argv) -ge 2
                commandline -r "nix run nixpkgs#$program -- $argv[2..-1]"
            else
                commandline -r "nix run nixpkgs#$program"
            end
            commandline -f execute
          '';
        };
        nix-fzf = {
          body = ''
            commandline -i (nix-instantiate --eval --json \
              -E 'builtins.attrNames (import <nixpkgs> {})' \
              | jq '.[]' -r | fzf)
            commandline -f repaint
          '';
        };
        rebuild-nixos = {
          body = ''
            git -C ${config.dotfilesPath} add --intent-to-add --all
            echo "doas nixos-rebuild switch --flake ${config.dotfilesPath}#${config.networking.hostName}"
          '';
        };
        rebuild-nixos-offline = {
          body = ''
            git -C ${config.dotfilesPath} add --intent-to-add --all
            echo "doas nixos-rebuild switch --option substitute false --flake ${config.dotfilesPath}#${config.networking.hostName}"
          '';
        };
        rebuild-home = {
          body = ''
            git -C ${config.dotfilesPath} add --intent-to-add --all
            echo "${pkgs.home-manager}/bin/home-manager switch --flake ${config.dotfilesPath}#${config.networking.hostName}";
          '';
        };
      };
    };

    # Provides "command-not-found" options
    programs.nix-index = {
      enable = false;
      enableFishIntegration = false;
    };

    # Create nix-index if doesn't exist
    home.activation.createNixIndex =
      let
        cacheDir = "${config.homePath}/.cache/nix-index";
      in
      lib.mkIf config.home-manager.users.${config.user}.programs.nix-index.enable (
        config.home-manager.users.${config.user}.lib.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -d ${cacheDir} ]; then
              $DRY_RUN_CMD ${pkgs.nix-index}/bin/nix-index -f ${pkgs.path}
          fi
        ''
      );

    # Set automatic generation cleanup for home-manager
    nix.gc = {
      automatic = config.nix.gc.automatic;
      options = config.nix.gc.options;
    };
  };

  nix = {

    # Set channel to flake packages, used for nix-shell commands
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    # For security, only allow specific users
    settings.allowed-users = [
      "@wheel"
      config.user
    ];

    # Enable features in Nix commands
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };

    settings = {

      # Add community Cachix to binary cache
      # Don't use with macOS because blocked by corporate firewall
      builders-use-substitutes = true;
      substituters = lib.mkIf (!pkgs.stdenv.isDarwin) [ "https://nix-community.cachix.org" ];
      trusted-public-keys = lib.mkIf (!pkgs.stdenv.isDarwin) [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Scans and hard links identical files in the store
      # Not working with macOS: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = lib.mkIf (!pkgs.stdenv.isDarwin) true;
    };
  };
}
