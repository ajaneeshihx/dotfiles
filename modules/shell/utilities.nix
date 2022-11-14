{ config, pkgs, ... }:

let

  ignorePatterns = ''
    !.env*
    !.github/
    !.gitignore
    !*.tfvars
    .terraform/
    .target/
    /Library/'';

in {

  config = {

    home-manager.users.${config.user} = {

      home.packages = with pkgs; [
        unzip # Extract zips
        rsync # Copy folders
        ripgrep # grep
        fd # find
        sd # sed
        jq # JSON manipulation
        tealdeer # Cheatsheets
        tree # View directory hierarchy
        htop # Show system processes
        glow # Pretty markdown previews
        qrencode # Generate qr codes
        vimv-rs # Batch rename files
        dig # DNS lookup
        lf # File viewer
        inetutils # Includes telnet, whois
        age # Encryption
      ];

      programs.zoxide.enable = true; # Shortcut jump command

      home.file = {
        ".rgignore".text = ignorePatterns;
        ".fdignore".text = ignorePatterns;
        ".digrc".text = "+noall +answer"; # Cleaner dig commands
      };

      programs.bat = {
        enable = true; # cat replacement
        config = { theme = config.theme.colors.batTheme; };
      };

      programs.fish.shellAbbrs = {
        cat = "bat"; # Swap cat with bat
      };

      programs.fish.functions = {
        ping = {
          description = "Improved ping";
          argumentNames = "target";
          body = "${pkgs.prettyping}/bin/prettyping --nolegend $target";
        };
      };

    };

  };

}
