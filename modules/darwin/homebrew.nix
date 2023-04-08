{ config, pkgs, lib, ... }: {

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {

    # Requires Homebrew to be installed
    system.activationScripts.preUserActivation.text = ''
      if ! xcode-select --version 2>/dev/null; then
        $DRY_RUN_CMD xcode-select --install
      fi
      if ! /usr/local/bin/brew --version 2>/dev/null; then
        $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false; # Don't update during rebuild
        cleanup = "zap"; # Uninstall all programs not declared
        upgrade = true;
      };
      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };
      taps = [
        "homebrew/cask" # Required for casks
        "homebrew/cask-drivers" # Used for Logitech G-Hub
      ];
      brews = [
        "trash" # Delete files and folders to trash instead of rm
        "openjdk" # Required by Apache Directory Studio
      ];
      casks = [
        "1password" # 1Password packaging on Nix is broken for macOS
        "apache-directory-studio" # Packaging on Nix is not available for macOS
        "gitify" # Git notifications in menu bar
        "keybase" # GUI on Nix not available for macOS
        "logitech-g-hub" # Mouse and keyboard management
        "meetingbar" # Show meetings in menu bar
        "mimestream" # Gmail client
        "obsidian" # Obsidian packaging on Nix is not available for macOS
        "scroll-reverser" # Different scroll style for mouse vs. trackpad
        "steam" # Not packaged for Nix
      ];
    };

  };

}
