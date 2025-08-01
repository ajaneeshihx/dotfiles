{ config, pkgs, lib, inputs, overlays, globals, ... }: {
  # Unified Home Manager configuration for all machines
  
  home.username = globals.user;
  home.homeDirectory = "/home/${globals.user}";
  home.stateVersion = "24.05";
  
  # Import common modules
  imports = [
    # Core applications and configurations
    ../modules/common/applications/home-manager.nix
    ../modules/common/applications/age.nix
    ../modules/common/applications/i3.nix
    ../modules/common/shell.nix
    ../modules/common/git.nix
    ../modules/common/emacs.nix
    ../modules/common/terminals.nix
    
    # Programming languages and tools
    ../modules/common/programming/clojure.nix
    ../modules/common/programming/claudecode.nix
    ../modules/common/programming/nodejs.nix
    ../modules/common/programming/language-servers.nix
  ];
  
  # Enable claude-code
  claudecode.enable = true;
  clojure.enable = true;
  
  # Enable i3 window manager
  i3.enable = true;
  
  # Apply overlays and config for standalone use
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfree = true;

  xdg.desktopEntries = {
    "google-chrome" = {
      name = "Google Chrome";
      exec = "google-chrome-stable";
      icon = "google-chrome";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
    };
  };
  
  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrains Mono" "Hack" "DejaVu Sans Mono" ];
      sansSerif = [ "Source Sans Pro" "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };
  
  # Common applications for all machines
  home.packages = with pkgs; [
    google-chrome
    postgresql
    # Core applications (available on all machines)
    
    # Desktop applications (will work on all machines with i3+Xephyr)  
    # nautilus       # File manager - REMOVED
    # _1password-cli # Password manager CLI - COMMENTED OUT
    # keybase        # Keybase client - COMMENTED OUT
    # charm          # Development tools - COMMENTED OUT
    
    # i3 and Xephyr dependencies
    xorg.xorgserver  # Provides Xephyr
    rofi             # Application launcher
    
    # WSL/i3 utilities
    xclip            # Clipboard integration
    i3-resurrect     # Session saving/restoring
    xorg.xrdb        # X resource database
    xorg.xkill       # Kill X applications
    xorg.xrandr      # Display information (for startx script)
    feh              # Background image setter
    picom            # Compositor
    dunst            # Notification daemon
    
    # Terminal info and utilities
    ncurses          # Terminal capabilities
    procps           # For pkill command in startx script
    
    # Fonts for proper display
    meslo-lgs-nf                    # Powerline font
    emacs-all-the-icons-fonts       # Icons for treemacs and other Emacs packages
    jetbrains-mono                  # Programming font
    fira-code                       # Programming font with ligatures
    hack-font                       # Clean monospace font
    iosevka                         # Narrow programming font
    victor-mono                     # Cursive programming font
    nerd-fonts.hack                 # Nerd Font version of Hack
    dejavu_fonts                    # Standard fonts
    noto-fonts                      # Unicode fonts
    noto-fonts-emoji                # Emoji fonts
    source-sans-pro                 # Sans serif font
    
    # Xephyr i3 launcher (renamed from i3-xephyr to startx) - ENHANCED FOR MULTI-DISPLAY
    (writeShellScriptBin "startx" ''
      #!/usr/bin/env bash

      # Enhanced i3-xephyr: Launch i3 window manager in a nested X server using Xephyr
      # Multi-display aware with adaptive DPI and auto-refresh support

      # Parse command line arguments
      ADAPTIVE_DPI=true
      AUTO_REFRESH=true
      CUSTOM_DPI="''${1#*=}"
      
      while [[ $# -gt 0 ]]; do
        case $1 in
          --dpi=*)
            CUSTOM_DPI="''${1#*=}"
            ADAPTIVE_DPI=false
            shift
            ;;
          --no-adaptive-dpi)
            ADAPTIVE_DPI=false
            shift
            ;;
          --no-auto-refresh)
            AUTO_REFRESH=false
            shift
            ;;
          -h|--help)
            echo "Usage: startx [OPTIONS]"
            echo "Options:"
            echo "  --dpi=NUMBER        Set custom DPI (disables adaptive DPI)"
            echo "  --no-adaptive-dpi   Use fixed DPI instead of adaptive"
            echo "  --no-auto-refresh   Disable automatic xrandr refresh"
            echo "  -h, --help          Show this help"
            exit 0
            ;;
          *)
            echo "Unknown option: $1"
            exit 1
            ;;
        esac
      done

      # Find an available display number
      DISPLAY_NUM=1
      while [ -S "/tmp/.X11-unix/X$DISPLAY_NUM" ] || [ -f "/tmp/.X$DISPLAY_NUM-lock" ]; do
          DISPLAY_NUM=$((DISPLAY_NUM + 1))
      done

      XEPHYR_DISPLAY=":$DISPLAY_NUM"

      # Get display information
      DISPLAY_INFO=$(${xorg.xrandr}/bin/xrandr | grep ' connected primary\|^[^ ].*connected' | head -1)
      
      if [ -n "$DISPLAY_INFO" ]; then
          # Extract resolution
          RESOLUTION=$(echo "$DISPLAY_INFO" | grep -o '[0-9]*x[0-9]*' | head -1)
          # Extract physical size for DPI calculation
          PHYSICAL_SIZE=$(echo "$DISPLAY_INFO" | grep -o '[0-9]*mm x [0-9]*mm')
          
          if [ -n "$RESOLUTION" ]; then
              WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
              HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)
              # Use 80% of display size
              SCREEN_WIDTH=$((WIDTH * 80 / 100))
              SCREEN_HEIGHT=$((HEIGHT * 80 / 100))
              SCREEN_SIZE="$SCREEN_WIDTH"x"$SCREEN_HEIGHT"
              
              # Calculate adaptive DPI if enabled
              if [ "$ADAPTIVE_DPI" = true ] && [ -n "$PHYSICAL_SIZE" ]; then
                  PHYSICAL_WIDTH=$(echo "$PHYSICAL_SIZE" | cut -d' ' -f1 | sed 's/mm//')
                  if [ -n "$PHYSICAL_WIDTH" ] && [ "$PHYSICAL_WIDTH" -gt 0 ]; then
                      # Calculate DPI: (pixels / mm) * 25.4
                      DPI=$(( (WIDTH * 254) / (PHYSICAL_WIDTH * 10) ))
                      # Clamp DPI to reasonable range (96-200)
                      if [ "$DPI" -lt 96 ]; then DPI=96; fi
                      if [ "$DPI" -gt 200 ]; then DPI=200; fi
                      echo "Calculated DPI: $DPI (from resolution $RESOLUTION, physical size $PHYSICAL_SIZE)"
                  else
                      DPI=120  # Default for adaptive mode
                  fi
              elif [ -n "$CUSTOM_DPI" ]; then
                  DPI="$CUSTOM_DPI"
                  echo "Using custom DPI: $DPI"
              else
                  DPI=120  # Conservative default for multi-display setups
                  echo "Using fixed DPI: $DPI"
              fi
          else
              SCREEN_SIZE="1400x900"
              DPI=120
          fi
      else
          SCREEN_SIZE="1400x900"
          DPI=120
      fi

      echo "Using display $XEPHYR_DISPLAY with size $SCREEN_SIZE, DPI $DPI"

      # Kill any existing Xephyr instance on our display
      ${pkgs.procps}/bin/pkill -f "Xephyr.*:$DISPLAY_NUM"

      # Start Xephyr with calculated DPI and enhanced options
      ${xorg.xorgserver}/bin/Xephyr "$XEPHYR_DISPLAY" \
          -ac \
          -host-cursor \
          -reset \
          -terminate \
          -dpi "$DPI" \
          -screen "$SCREEN_SIZE" \
          -resizeable \
          -retro &
      XEPHYR_PID=$!

      # Wait for Xephyr to start
      sleep 3

      # Check if Xephyr is running
      if ! kill -0 $XEPHYR_PID 2>/dev/null; then
          echo "Failed to start Xephyr"
          exit 1
      fi

      # Set up the nested display environment
      export NESTED_DISPLAY="$XEPHYR_DISPLAY"

      # Start i3 in the nested X server
      echo "Starting i3 on display $XEPHYR_DISPLAY..."
      DISPLAY="$XEPHYR_DISPLAY" ${i3}/bin/i3 &
      I3_PID=$!

      # Wait a bit for i3 to start
      sleep 2

      # Set up auto-refresh if enabled
      if [ "$AUTO_REFRESH" = true ]; then
          # Background process to monitor for window resizes and auto-refresh
          (
              while kill -0 $XEPHYR_PID 2>/dev/null; do
                  sleep 5
                  # Refresh the display to fix canvas expansion issues
                  DISPLAY="$XEPHYR_DISPLAY" ${xorg.xrandr}/bin/xrandr -q >/dev/null 2>&1 || true
              done
          ) &
          REFRESH_PID=$!
      fi

      # Focus the Xephyr window by starting a simple application
      DISPLAY="$XEPHYR_DISPLAY" ${xterm}/bin/xterm -fa "JetBrains Mono" -fs 9 -e "echo 'i3 workspace ready. DPI: $DPI | Use Alt+Enter for terminal, Alt+d for dmenu, Alt+p for rofi | Alt+Shift+F5 to refresh display'; sleep 3" &

      # Function to cleanup on exit
      cleanup() {
          echo "Cleaning up..."
          [ -n "$REFRESH_PID" ] && kill "$REFRESH_PID" 2>/dev/null
          [ -n "$I3_PID" ] && kill "$I3_PID" 2>/dev/null
          [ -n "$XEPHYR_PID" ] && kill "$XEPHYR_PID" 2>/dev/null
          exit 0
      }

      # Set up signal handlers
      trap cleanup SIGINT SIGTERM

      echo "i3 running in Xephyr on display $XEPHYR_DISPLAY (DPI: $DPI)"
      echo "Auto-refresh: $AUTO_REFRESH | Adaptive DPI: $ADAPTIVE_DPI"
      echo "Press Ctrl+C to exit"
      echo ""
      echo "Tips:"
      echo "- Use 'startx --dpi=96' for smaller fonts"
      echo "- Use 'startx --dpi=144' for larger fonts" 
      echo "- Use Alt+Shift+F5 inside i3 to manually refresh display"

      # Wait for processes to finish
      wait $I3_PID
      cleanup
    '')
  ];
}
