# Replace sudo with doas

{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf pkgs.stdenv.isLinux {

    security = {

      # Remove sudo
      sudo.enable = true;

      # Add doas
      doas = {
        enable = true;

        # No password required for trusted users
        wheelNeedsPassword = false;

        # Pass environment variables from user to root
        # Also requires specifying that we are removing password here
        extraRules = [
          {
            groups = [ "wheel" ];
            noPass = true;
            keepEnv = true;
          }
        ];
      };
    };

    home-manager.users.${config.user}.programs = {

      zsh.shellAliases = {
	# sudo = "doas";
      };

      # Disable overriding our sudo alias with a TERMINFO alias
      kitty.settings.shell_integration = "no-sudo";
    };
  };
}
