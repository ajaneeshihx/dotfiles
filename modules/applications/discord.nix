{ config, pkgs, lib, ... }: {

  config = lib.mkIf config.gui.enable {
    unfreePackages = [ "discord" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ discord ];
      xdg.configFile."discord/settings.json".text = ''
        {
          "BACKGROUND_COLOR": "#202225",
          "IS_MAXIMIZED": false,
          "IS_MINIMIZED": false,
          "OPEN_ON_STARTUP": false,
          "MINIMIZE_TO_TRAY": false,
          "SKIP_HOST_UPDATE": true
        }
      '';
    };
  };
}