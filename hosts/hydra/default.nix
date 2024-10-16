# The Hydra
# System configuration for WSL

# See [readme](../README.md) to explain how this file works.

{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    ../../modules/common
    ../../modules/nixos
    ../../modules/wsl
    globals
    inputs.wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      networking.hostName = "hydra";
      nixpkgs.overlays = overlays;
      identityFile = "/home/${globals.user}/.ssh/id_ed25519";
      gui.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox).dark;
        dark = true;
      };
      wallpaper = "${inputs.wallpapers}/gruvbox/road.jpg";
      gtk.theme.name = "Adwaita-dark";
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
      wsl = {
        enable = true;
        wslConf.automount.root = "/mnt";
        defaultUser = globals.user;
        startMenuLaunchers = true;
        nativeSystemd = true;
        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
        interop.includePath = false; # Including Windows PATH will slow down Neovim command mode
      };

      services.vscode-server.enable = true;
      services.emacs.enable = true;
      services.xserver.enable = true;
      vscode.enable = true;
      emacs.enable = true;
      # neovim.enable = true;
      # mail.enable = true;
      # mail.aerc.enable = true;
      # mail.himalaya.enable = true;
      dotfiles.enable = true;
      lua.enable = true;
    }
  ];
}
