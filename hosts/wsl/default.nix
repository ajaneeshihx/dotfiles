{ nixpkgs, wsl, home-manager, globals, ... }:

# System configuration for WSL
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    globals
    wsl.nixosModules.wsl
    home-manager.nixosModules.home-manager
    {
      networking.hostName = "wsl";
      gui.enable = false;
      gui.colorscheme = (import ../../modules/colorscheme/gruvbox);
      passwordHash =
        "$6$PZYiMGmJIIHAepTM$Wx5EqTQ5GApzXx58nvi8azh16pdxrN6Qrv1wunDlzveOgawitWzcIxuj76X9V868fsPi/NOIEO8yVXqwzS9UF.";
      wsl = {
        enable = true;
        automountPath = "/mnt";
        defaultUser = globals.user;
        startMenuLaunchers = true;
        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
        interop.includePath =
          false; # Including Windows PATH will slow down Neovim command mode
      };
    }
    ../common.nix
    ../../modules/wsl
    ../../modules/nixos
    ../../modules/mail/himalaya.nix
    ../../modules/programming/nix.nix
    ../../modules/programming/lua.nix
  ];
}
