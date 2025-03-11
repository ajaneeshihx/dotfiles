{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./integration.nix
    ./i3.nix
  ];

  config = lib.mkIf (pkgs.stdenv.isLinux && config.wsl.enable) {
    # Systemd doesn't work in WSL without native systemd
    services.geoclue2.enable = lib.mkForce false;
    location = {
      provider = lib.mkForce "manual";
    };
    services.localtimed.enable = lib.mkForce false;

    home-manager.users.${config.user} = {

      # Clipboard sharing with Windows and i3 launcher script
      home.packages = with pkgs; [

        xorg.xrdb
        
        # terminfo
        ncurses

        # Window manager and GUI essentials
        dmenu
        feh
        picom
        dunst
        wezterm
        tmux
        xterm
        alacritty
        rxvt-unicode
        
        (pkgs.writeShellScriptBin "xterm-with-config" ''
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xresources
          exec ${pkgs.rxvt-unicode}/bin/urxvt "$@"
        '')

      ];

      home.file.".Xresources".text = ''
! special
URxvt.foreground:   #c5c8c6
URxvt.background:   #1d1f21
URxvt.cursorColor:  #c5c8c6

! black
URxvt.color0:       #282a2e
URxvt.color8:       #373b41

! red
URxvt.color1:       #a54242
URxvt.color9:       #cc6666

! green
URxvt.color2:       #8c9440
URxvt.color10:      #b5bd68

! yellow
URxvt.color3:       #de935f
URxvt.color11:      #f0c674

! blue
URxvt.color4:       #5f819d
URxvt.color12:      #81a2be

! magenta
URxvt.color5:       #85678f
URxvt.color13:      #b294bb

! cyan
URxvt.color6:       #5e8d87
URxvt.color14:      #8abeb7

! white
URxvt.color7:       #707880
URxvt.color15:      #c5c8c6

!! URxvt Appearance
URxvt.letterSpace: 0
URxvt.lineSpace: 0
URxvt.geometry: 92x24
URxvt.internalBorder: 6
URxvt.cursorBlink: true
URxvt.cursorUnderline: false
URxvt.saveline: 2048
URxvt.scrollBar: false
URxvt.scrollBar_right: false
URxvt.urgentOnBell: true
URxvt.depth: 24
URxvt.iso14755: false
URxvt.font: xft:JetBrains Mono:size=10
        '';
      
    };
  };
}
