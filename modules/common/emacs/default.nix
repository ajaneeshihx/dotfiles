{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.emacs.enable = lib.mkEnableOption "emacs and related packages";

  config = lib.mkIf config.emacs.enable {

    home-manager.users.${config.user} = {

      home.packages = with pkgs; [
        (texlive.combine {
          inherit (texlive) 
            scheme-minimal  # Bare minimum
            latex-bin       # LaTeX binaries
            latex           # Basic LaTeX packages
            dvipng          # DVI to PNG converter
            dvisvgm         # Alternative DVI converter
          # Any other TeX packages you might need
          ;
        })
        # Language servers for Eglot
        python3Packages.python-lsp-server  # pylsp for Python
        nodePackages.typescript-language-server  # TypeScript/JavaScript LSP
        nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON LSP
        nodePackages.yaml-language-server  # YAML LSP
        terraform-ls  # Terraform LSP
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacs-gtk;
        # package = (pkgs.emacs.override { withXwidgets = true; withGTK3 = true; });
	      extraPackages = epkgs: with epkgs; [
          aggressive-indent
          all-the-icons
          all-the-icons
          all-the-icons-completion
          # JavaScript/TypeScript packages
          add-node-modules-path
          js2-mode
          prettier-js
          rjsx-mode
          typescript-mode
          web-mode
          # Config file packages
          csv-mode
          dockerfile-mode
          markdown-mode
          nginx-mode
          systemd
          terraform-mode
          toml-mode
          yaml-mode
          # Tree-sitter packages
          treesit-grammars.with-all-grammars
          # Productivity packages
          avy
          dashboard
          diff-hl
          evil-anzu
          evil-goggles
          helpful
          highlight-indent-guides
          multiple-cursors
          rainbow-mode
          # Python enhancements
          dap-mode
          ein
          poetry
          # Org enhancements
          ob-restclient
          org-bullets
          org-download
          # Existing packages
          cape
          cider
          clj-refactor
          clojure-mode
          clojure-snippets
          consult-lsp
          consult-project-extra
          corfu
          coverage
          eat
          embark
          embark-consult
          evil
          evil-collection
          evil-commentary
          evil-matchit
          evil-surround
          expand-region
          feature-mode
          flycheck
          flycheck-clj-kondo
          htmlize
          json-mode
          ligature
          lsp-pyright
          magit
          magit-section
          marginalia
          mixed-pitch
          modus-themes
          move-text
          mu4e-alert
          nix-mode
          olivetti
          orderless
          org-superstar
          org-msg
          org-mime
          org-roam
          org-roam-ui
          paredit
          pkgs.emacsPackagesCustom.mu4e-dashboard
          pkgs.emacsPackagesCustom.emacs-claude-code
          py-isort
          pytest
          python-black
          pyvenv
          rainbow-delimiters
          restclient
          smartparens
          transient
          treemacs
          treemacs-all-the-icons
          undo-tree
          vertico
          wgrep
          which-key
          # Folding packages
          origami
          yafolding
          yasnippet
          yasnippet-capf
          yasnippet-snippets
	      ];
      };

      # Create helper scripts
      xdg.configFile."emacs/mu4e-dashboard.org" = {
        executable = false;
        text = ''

* Mu for Emacs (mu4e)                                        *[[mu:flag:unread|%3d Unread][ 17 Unread]]*

[[mu:flag:unread][Unread]] /[[mu:flag:unread|(%3d)][( 17)]]/ .... [u]  [[mu:date:today..now][Today]] /[[mu:date:today..now|(%3d)][(113)]]/ .......... [t]  *Compose* ...... [C]
[[mu:m:/inria/inbox or m:/gmail/inbox or m:/univ/inbox][Inbox]]  /[[mu:m:/inria/inbox or m:/gmail/inbox or m:/univ/inbox|(%3d)][( 33)]]/ .... [i]  [[mu:date:2d..today and not date:today..now][Yesterday]] /[[mu:date:2d..today and not date:today..now|(%3d)][(242)]]/ ...... [y]  *Update* ....... [U]
[[mu:m:/inria/drafts or m:/gmail/drafts or m:/univ/drafts][Drafts]] /[[mu:m:/inria/drafts or m:/gmail/drafts or m:/univ/drafts|(%3d)][(  2)]]/ .... [d]  [[mu:date:7d..now][Last week]] /[[mu:date:7d..now|(%4d)][( 989)]]/ ..... [w]  *Switch context* [;]
[[mu:m:/inria/sent or m:/gmail/sent or m:/univ/sent][Sent]] /[[mu:m:/inria/sent or m:/gmail/sent or m:/univ/sent|(%5d)][( 7082)]]/ .... [s]  [[mu:date:4w..now][Last month]] /[[mu:date:4w..|(%4d)][(3606)]]/ .... [m]  *Quit* ......... [q]

* Queries

Type *C-c C-c* on the /CALL/ line below to evaluate your query.
*NOTE*: dashboard needs to be deactivated first

#+CALL: query("flag:unread", 5)
#+RESULTS:

* Saved searches

[[mu:m:/inria/archive or m:/gmail/archive or m:/univ/archive][Archive]] /[[mu:m:/inria/archive or m:/gmail/archive or m:/univ/archive|(%6d)][( 44132)]]/ ...... [[mu:m:/inria/archive or m:/gmail/archive or m:/univ/archive||100][100]] - [[mu:m:/inria/archive or m:/gmail/archive or m:/univ/archive||500][500]]  [[mu:flag:attach][ Attachments]] /[[mu:flag:attach|(%5d)][( 9954)]]/ ... [[mu:flag:attach||99999][all]] - [[mu:size:10M..][big]]
[[mu:flag:flagged][Important]] /[[mu:flag:flagged|(%4d)][( 278)]]/ ...... [[mu:flag:flagged||100][100]] - [[mu:flag:flagged||500][500]]   [[mu:flag:encrypted][Encrypted]] /[[mu:flag:encrypted|(%4d)][( 888)]]/ ...... [[mu:flag:encrypted||100][100]] - [[mu:flag:encrypted||500][500]]

** People 

[[mu:from:rms@gnu.org][Richard Stallman]] /[[mu:from:rms@gnu.org|(%3d)][(508)]]/ ............................ [[mu:mu:from:rms@gnu.org||100][100]] - [[mu:from:rms@gnu.org||500][500]] - [[mu:from:rms@gnu.org||9999][all]]
[[mu:from:djcb@djcbsoftware.nl][Dirk-Jan C. Binnema]] /[[mu:from:djcb@djcbsoftware.nl|(%2d)][(50)]]/ .......................... [[mu:from:djcb@djcbsoftware.nl||100][100]] - [[mu:from:djcb@djcbsoftware.nl||500][500]] - [[mu:from:djcb@djcbsoftware.nl||9999][all]]

** Date

[[mu:date:20200101..20201231][Year 2020]] /[[mu:date:20200101..20201231|(%5d)][(28340)]]/ [[mu:date:20190101..20191231][       Year 2019]] /[[mu:date:20190101..20191231|(%5d)][(19845)]]/ [[mu:date:20180101..20181231][       Year 2018]] /[[mu:date:20180101..20181231|(%5d)][( 3038)]]/

** Mailing lists

[[mu:list:emacs-devel.gnu.org
 ][Emacs development]] /[[mu:list:emacs-devel.gnu.org|(%4d)][(3208)]]/ .......................... [[mu:list:emacs-devel.gnu.org||100][100]] - [[mu:list:emacs-devel.gnu.org||500][500]] - [[mu:list:emacs-devel.gnu.org||9999][all]]
[[mu:list:mu-discuss.googlegroups.com][Mu4e discussions]] /[[mu:list:mu-discuss.googlegroups.com|(%4d)][( 267)]]/ ........................... [[mu:list:mu-discuss.googlegroups.com||100][100]] - [[mu:list:mu-discuss.googlegroups.com||500][500]] - [[mu:list:mu-discuss.googlegroups.com||9999][all]]

* Information

*Database*  : ~/.cache/mu/xapian
*Maildir*   : ~/Documents/Mail-isync
*Addresses* : [[mailto:nicolas.rougier@inria.fr][<nicolas.rougier@inria.fr>]] /(inria)/
            [[mailto:nicolas.rougier@gmail.com][<nicolas.rougier@gmail.com>]] /(gmail)/
            [[mailto:nicolas.rougier@u-bordeaux.fr][<nicolas.rougier@u-bordeaux.fr>]] /(univ)/

* Configuration
:PROPERTIES:
:VISIBILITY: hideall
:END:

#+STARTUP: showall showstars indent

#+NAME: query
#+BEGIN_SRC sh :results list raw :var query="flag:unread" count=5 
export LANG="en_US.UTF-8"; export LC_ALL="en_US.UTF-8";
mu find -n $count --sortfield=date --reverse --fields "f s" $query
#+END_SRC

#+KEYMAP: u | mu4e-headers-search "flag:unread"
#+KEYMAP: i | mu4e-headers-search "m:/inria/inbox or m:/gmail/inbox or m:/univ/inbox"
#+KEYMAP: d | mu4e-headers-search "m:/inria/drafts or m:/gmail/drafts or m:/univ/drafts"
#+KEYMAP: s | mu4e-headers-search "m:/inria/sent or m:/gmail/sent or m:/univ/sent"

#+KEYMAP: t | mu4e-headers-search "date:today..now"
#+KEYMAP: y | mu4e-headers-search "date:2d..today and not date:today..now"
#+KEYMAP: w | mu4e-headers-search "date:7d..now"
#+KEYMAP: m | mu4e-headers-search "date:4w..now"

#+KEYMAP: C | mu4e-compose-new
#+KEYMAP: U | mu4e-dashboard-update
#+KEYMAP: ; | mu4e-context-switch
#+KEYMAP: q | kill-current-buffer
 
        '';
      };
      
      home.file."org/roam/.keep".text = "";
      
    };

  };
}
