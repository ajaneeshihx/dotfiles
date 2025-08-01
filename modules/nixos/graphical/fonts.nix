{
  config,
  pkgs,
  lib,
  ...
}:

let
  fontName = "Victor Mono";
in
{

  config = lib.mkIf (config.gui.enable && pkgs.stdenv.isLinux) {

    fonts.packages = with pkgs; [
      meslo-lgs-nf
      emacs-all-the-icons-fonts
      etBook
      jetbrains-mono
      source-sans-pro
      fira-code
      hack-font
      iosevka
      victor-mono # Used for Vim and Terminal
      nerd-fonts.hack # For Polybar, Rofi
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
    ];
    fonts.fontconfig.defaultFonts.monospace = [ fontName ];

    home-manager.users.${config.user} = {
      xsession.windowManager.i3.config.fonts = {
        names = [ "pango:${fontName}" ];
        # style = "Regular";
        # size = 11.0;
      };
      services.polybar.config."bar/main".font-0 = "Hack Nerd Font:size=9;2";
      programs.rofi.font = "Hack Nerd Font 12";
      programs.alacritty.settings.font.normal.family = fontName;
      programs.kitty.font.name = fontName;
      services.dunst.settings.global.font = "Hack Nerd Font 12";
    };
  };
}
