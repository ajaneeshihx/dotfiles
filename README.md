# System Configurations

This repository contains configuration files for my NixOS, macOS, and WSL
hosts.

They are organized and managed by [Nix](https://nixos.org), so some of the
configuration may be difficult to translate to a non-Nix system.

## System Features

| Feature        | Program                                             | Configuration                                 |
| ---            | ---                                                 | ---                                           |
| OS             | [NixOS](https://nixos.org)                          | [Link](./modules/nixos)                       |
| Display Server | [X11](https://www.x.org/wiki/)                      | [Link](./modules/nixos/graphical/xorg.nix)    |
| Compositor     | [Picom](https://github.com/yshui/picom)             | [Link](./modules/nixos/graphical/picom.nix)   |
| Window Manager | [i3](https://i3wm.org/)                             | [Link](./modules/nixos/graphical/i3.nix)      |
| Panel          | [Polybar](https://polybar.github.io/)               | [Link](./modules/nixos/graphical/polybar.nix) |
| Font           | [Victor Mono](https://rubjo.github.io/victor-mono/) | [Link](./modules/nixos/graphical/fonts.nix)   |
| Launcher       | [Rofi](https://github.com/davatorium/rofi)          | [Link](./modules/nixos/graphical/rofi.nix)    |

## User Features

| Feature      | Program                                                                          | Configuration                                      |
| ---          | ---                                                                              | ---                                                |
| Dotfiles     | [Home-Manager](https://github.com/nix-community/home-manager)                    | [Link](./modules/common)                           |
| Terminal     | [Kitty](https://sw.kovidgoyal.net/kitty/)                                        | [Link](./modules/common/applications/kitty.nix)    |
| Shell        | [Fish](https://fishshell.com/)                                                   | [Link](./modules/common/shell/fish)                |
| Shell Prompt | [Starship](https://starship.rs/)                                                 | [Link](./modules/common/shell/starhip.nix)         |
| Colorscheme  | [Gruvbox](https://github.com/morhetz/gruvbox)                                    | [Link](./colorscheme/gruvbox)                      |
| Wallpaper    | [Road](https://gitlab.com/exorcist365/wallpapers/-/blob/master/gruvbox/road.jpg) | [Link](./hosts/tempest/default.nix)
| Text Editor  | [Neovim](https://neovim.io/)                                                     | [Link](./modules/common/neovim/config)             |
| Browser      | [Firefox](https://www.mozilla.org/en-US/firefox/new/)                            | [Link](./modules/common/applications/firefox.nix)  |
| E-Mail       | [Aerc](https://aerc-mail.org/)                                                   | [Link](./modules/common/mail/aerc.nix)             |
| File Manager | [Nautilus](https://wiki.gnome.org/action/show/Apps/Files)                        | [Link](./modules/common/applications/nautilus.nix) |
| PDF Reader   | [Zathura](https://pwmt.org/projects/zathura/)                                    | [Link](./modules/common/applications/media.nix)    |
| Video Player | [mpv](https://mpv.io/)                                                           | [Link](./modules/common/applications/media.nix)    |

## macOS Features

| Feature  | Program                                     | Configuration                        |
| ---      | ---                                         | ---                                  |
| Keybinds | [Hammerspoon](https://www.hammerspoon.org/) | [Link](./modules/darwin/hammerspoon) |

---

# Installation

Click [here](./docs/installation.md) for detailed installation instructions.

# Neovim

Try out my Neovim config with nix:

```bash
nix run github:nmasur/dotfiles#neovim
```

Or build it as a package:

```bash
nix build github:nmasur/dotfiles#neovim
```

If you already have a Neovim configuration, you may need to move it out of
`~/.config/nvim` or set `XDG_CONFIG_HOME` to another value; otherwise both
configs might conflict with each other.

# Flake Templates

You can also use the [templates](./templates/) as flakes for starting new
projects:

```bash
nix flake init --template github:nmasur/dotfiles#poetry
```
