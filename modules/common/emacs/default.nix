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

        imports = [ ./init.nix ];

        programs.emacs = {
            enable = true;
        };

        programs.emacs.init = {
            enable = true;
            recommendedGcSettings = true;

            prelude = ''
            ;; Disable startup message.
            (setq inhibit-startup-message t
                    inhibit-startup-echo-area-message (user-login-name))

            (setq initial-major-mode 'fundamental-mode
                    initial-scratch-message nil)

            ;; Disable some GUI distractions.
            (tool-bar-mode -1)
            (scroll-bar-mode -1)
            (menu-bar-mode -1)
            (blink-cursor-mode 0)

            ;; Set up fonts early.
            (set-face-attribute 'default
                                nil
                                :height 80
                                :family "Firacode Mono")
            (set-face-attribute 'variable-pitch
                                nil
                                :family "Firacode Sans")

            ;; Set frame title.
            (setq frame-title-format
                    '("" invocation-name ": "(:eval
                                            (if (buffer-file-name)
                                                (abbreviate-file-name (buffer-file-name))
                                                "%b"))))

            ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
            (defalias 'yes-or-no-p 'y-or-n-p)

            ;; Don't want to move based on visual line.
            (setq line-move-visual nil)

            ;; Stop creating backup and autosave files.
            (setq make-backup-files nil
                    auto-save-default nil)

            ;; Always show line and column number in the mode line.
            (line-number-mode)
            (column-number-mode)

            ;; Enable some features that are disabled by default.
            (put 'narrow-to-region 'disabled nil)

            ;; Typically, I only want spaces when pressing the TAB key. I also
            ;; want 4 of them.
            (setq-default indent-tabs-mode nil
                            tab-width 4
                            c-basic-offset 4)

            ;; Trailing white space are banned!
            (setq-default show-trailing-whitespace t)

            ;; Make a reasonable attempt at using one space sentence separation.
            (setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*"
                    sentence-end-double-space nil)

            ;; I typically want to use UTF-8.
            (prefer-coding-system 'utf-8)

            ;; Nicer handling of regions.
            (transient-mark-mode 1)

            ;; Make moving cursor past bottom only scroll a single line rather
            ;; than half a page.
            (setq scroll-step 1
                    scroll-conservatively 5)

            ;; Enable highlighting of current line.
            (global-hl-line-mode 1)

            ;; Improved handling of clipboard in GNU/Linux and otherwise.
            (setq select-enable-clipboard t
                    select-enable-primary t
                    save-interprogram-paste-before-kill t)

            ;; Pasting with middle click should insert at point, not where the
            ;; click happened.
            (setq mouse-yank-at-point t)

            ;; Enable a few useful commands that are initially disabled.
            (put 'upcase-region 'disabled nil)
            (put 'downcase-region 'disabled nil)

            ;; (setq custom-file (locate-user-emacs-file "custom.el"))
            ;; (load custom-file)

            ;; When finding file in non-existing directory, offer to create the
            ;; parent directory.
            (defun with-buffer-name-prompt-and-make-subdirs ()
                (let ((parent-directory (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p parent-directory))
                            (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
                    (make-directory parent-directory t))))

            (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

            ;; Don't want to complete .hi files.
            (add-to-list 'completion-ignored-extensions ".hi")

            ;; Shouldn't highlight trailing spaces in terminal mode.
            (add-hook 'term-mode (lambda () (setq show-trailing-whitespace nil)))
            (add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))
            '';

        usePackage = {
            abbrev = {
                enable = true;
                diminish = [ "abbrev-mode" ];
                command = [ "abbrev-mode" ];
            };

            adoc-mode = {
                enable = true;
                mode = [
                ''"\\.txt\\'"''
                ''"\\.adoc\\'"''
                ];
            };

            # ansi-color = {
            #     enable = true;
            #     command = [ "ansi-color-apply-on-region" ];
            # };

            autorevert = {
                enable = true;
                diminish = [ "auto-revert-mode" ];
                command = [ "auto-revert-mode" ];
            };

            back-button = {
                enable = true;
                defer = 1;
                diminish = [ "back-button-mode" ];
                command = [ "back-button-mode" ];
                config = ''
                (back-button-mode 1)

                ;; Make mark ring larger.
                (setq global-mark-ring-max 50)
                '';
            };

            # base16-theme = {
            #     enable = true;
            #     config = "(load-theme 'base16-tomorrow-night t)";
            # };

            # From https://github.com/mlb-/emacs.d/blob/a818e80f7790dffa4f6a775987c88691c4113d11/init.el#L472-L482
            # compile = {
            #     enable = true;
            #     defer = true;
            #     after = [ "ansi-color" ];
            #     hook = [
            #     ''
            #         (compilation-filter . (lambda ()
            #                                 (when (eq major-mode 'compilation-mode)
            #                                 (ansi-color-apply-on-region compilation-filter-start (point-max)))))
            #     ''
            #     ];
            # };

            # beacon = {
            #     enable = true;
            #     command = [ "beacon-mode" ];
            #     diminish = [ "beacon-mode" ];
            #     defer = 1;
            #     config = "(beacon-mode 1)";
            # };

            # cc-mode = {
            #     enable = true;
            #     defer = true;
            #     hook = [
            #     ''
            #         (c-mode-common . (lambda ()
            #                         (subword-mode)

            #                         (c-set-offset 'arglist-intro '++)))
            #     ''
            #     ];
            # };

            # deadgrep = {
            #     enable = true;
            #     bind = {
            #     "C-x f" = "deadgrep";
            #     };
            # };

            direnv = {
                enable = true;
                command = [ "direnv-mode" "direnv-update-environment" ];
            };

            # dhall-mode = {
            #     enable = true;
            #     mode = [ ''"\\.dhall\\'"'' ];
            # };

            dockerfile-mode = {
                enable = true;
                mode = [ ''"Dockerfile\\'"'' ];
            };

            doom-modeline = {
                enable = true;
                hook = [ "(after-init . doom-modeline-mode)" ];
                config = ''
                (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
                '';
            };

            drag-stuff = {
                enable = true;
                bind = {
                "M-<up>" = "drag-stuff-up";
                "M-<down>" = "drag-stuff-down";
                };
            };

            ediff = {
                enable = true;
                defer = true;
                config = ''
                (setq ediff-window-setup-function 'ediff-setup-windows-plain)
                '';
            };

            eldoc = {
                enable = true;
                diminish = [ "eldoc-mode" ];
                command = [ "eldoc-mode" ];
            };

            # Enable Electric Indent mode to do automatic indentation on RET.
            electric = {
                enable = true;
                command = [ "electric-indent-local-mode" ];
                hook = [
                "(prog-mode . electric-indent-mode)"

                # Disable for some modes.
                "(nix-mode . (lambda () (electric-indent-local-mode -1)))"
                ];
            };

            # etags = {
            #     enable = true;
            #     defer = true;
            #     # Avoid spamming reload requests of TAGS files.
            #     config = "(setq tags-revert-without-query t)";
            # };

            # ggtags = {
            #     enable = true;
            #     defer = true;
            #     diminish = [ "ggtags-mode" ];
            #     command = [ "ggtags-mode" ];
            # };

            # groovy-mode = {
            #     enable = true;
            #     mode = [
            #     ''"\\.gradle\\'"''
            #     ''"\\.groovy\\'"''
            #     ''"Jenkinsfile\\'"''
            #     ];
            # };

            # idris-mode = {
            #     enable = true;
            #     mode = [ ''"\\.idr\\'"'' ];
            # };

            ispell = {
                enable = true;
                defer = 1;
            };

            js = {
                enable = true;
                mode = [
                ''("\\.js\\'" . js-mode)''
                ''("\\.json\\'" . js-mode)''
                ];
                config = ''
                (setq js-indent-level 2)
                '';
            };

            notifications = {
                enable = true;
                command = [ "notifications-notify" ];
            };

            flyspell = {
                enable = true;
                diminish = [ "flyspell-mode" ];
                command = [ "flyspell-mode" "flyspell-prog-mode" ];
                hook = [
                # Spell check in text and programming mode.
                "(text-mode . flyspell-mode)"
                "(prog-mode . flyspell-prog-mode)"
                ];
                config = ''
                ;; In flyspell I typically do not want meta-tab expansion
                ;; since it often conflicts with the major mode. Also,
                ;; make it a bit less verbose.
                (setq flyspell-issue-message-flag nil
                        flyspell-issue-welcome-flag nil
                        flyspell-use-meta-tab nil)
                '';
            };

            # Remember where we where in a previously visited file. Built-in.
            saveplace = {
                enable = true;
                config = ''
                (setq-default save-place t)
                (setq save-place-file (locate-user-emacs-file "places"))
                '';
            };

            # More helpful buffer names. Built-in.
            uniquify = {
                enable = true;
                config = ''
                (setq uniquify-buffer-name-style 'post-forward)
                '';
            };

            # Hook up hippie expand.
            # hippie-exp = {
            #     enable = true;
            #     bind = {
            #     "M-?" = "hippie-expand";
            #     };
            # };

            which-key = {
                enable = true;
                command = [ "which-key-mode" ];
                diminish = [ "which-key-mode" ];
                defer = 2;
                config = "(which-key-mode)";
            };

            # Enable winner mode. This global minor mode allows you to
            # undo/redo changes to the window configuration. Uses the
            # commands C-c <left> and C-c <right>.
            # winner = {
            #     enable = true;
            #     config = "(winner-mode 1)";
            # };

            # writeroom-mode = {
            #     enable = true;
            #     command = [ "writeroom-mode" ];
            #     bind = {
            #     "M-[" = "writeroom-decrease-width";
            #     "M-]" = "writeroom-increase-width";
            #     };
            #     hook = [ "(writeroom-mode . visual-line-mode)" ];
            # };

            buffer-move = {
                enable = true;
                bind = {
                "C-S-<up>"    = "buf-move-up";
                "C-S-<down>"  = "buf-move-down";
                "C-S-<left>"  = "buf-move-left";
                "C-S-<right>" = "buf-move-right";
                };
            };

            # ivy = {
            #     enable = true;
            #     demand = true;
            #     diminish = [ "ivy-mode" ];
            #     command = [ "ivy-mode" ];
            #     config = ''
            #     (setq ivy-use-virtual-buffers t
            #             ivy-count-format "%d/%d "
            #             ivy-virtual-abbreviate 'full)

            #     (ivy-mode 1)
            #     '';
            # };

            # ivy-xref = {
            #     enable = true;
            #     after = [ "ivy" "xref" ];
            #     command = [ "ivy-xref-show-xrefs" ];
            #     config = ''
            #     (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
            #     '';
            # };

            # swiper = {
            #     enable = true;
            #     command = [ "swiper" "swiper-all" "swiper-isearch" ];
            #     bind = {
            #     "C-s" = "swiper-isearch";
            #     };
            # };

            # Lets counsel do prioritization. A fork of smex.
            # amx = {
            #     enable = true;
            #     command = [ "amx-initialize" ];
            # };

            # counsel = {
            #     enable = true;
            #     bind = {
            #     "C-x C-d" = "counsel-dired-jump";
            #     "C-x C-f" = "counsel-find-file";
            #     "C-x C-r" = "counsel-recentf";
            #     "C-x C-y" = "counsel-yank-pop";
            #     "M-x" = "counsel-M-x";
            #     };
            #     diminish = [ "counsel-mode" ];
            # };

            # nyan-mode = {
            #     enable = true;
            #     command = [ "nyan-mode" ];
            #     config = ''
            #     (setq nyan-wavy-trail t)
            #     '';
            # };

            # string-inflection = {
            #     enable = true;
            #     bind = {
            #     "C-c C-u" = "string-inflection-all-cycle";
            #     };
            # };

            # Configure magit, a nice mode for the git SCM.
            magit = {
                enable = true;
                bind = {
                "C-c g" = "magit-status";
                };
                config = ''
                (setq magit-completing-read-function 'ivy-completing-read)
                (add-to-list 'git-commit-style-convention-checks
                            'overlong-summary-line)
                '';
            };

            git-messenger = {
                enable = true;
                bind = {
                "C-x v p" = "git-messenger:popup-message";
                };
            };

            multiple-cursors = {
                enable = true;
                bind = {
                "C-S-c C-S-c" = "mc/edit-lines";
                "C-c m" = "mc/mark-all-like-this";
                "C->" = "mc/mark-next-like-this";
                "C-<" = "mc/mark-previous-like-this";
                };
            };

            nix-sandbox = {
                enable = true;
                command = [ "nix-current-sandbox" "nix-shell-command" ];
            };

            # avy = {
            #     enable = true;
            #     extraConfig = ''
            #     :bind* ("C-c SPC" . avy-goto-word-or-subword-1)
            #     '';
            # };

            # undo-tree = {
            #     enable = true;
            #     demand = true;
            #     diminish = [ "undo-tree-mode" ];
            #     command = [ "global-undo-tree-mode" ];
            #     config = ''
            #     (setq undo-tree-visualizer-relative-timestamps t
            #             undo-tree-visualizer-timestamps t)
            #     (global-undo-tree-mode)
            #     '';
            # };

            # Configure AUCTeX.
            # latex = {
            #     enable = true;
            #     package = epkgs: epkgs.auctex;
            #     mode = [ ''("\\.tex\\'" . latex-mode)'' ];
            #     hook = [
            #     ''
            #         (LaTeX-mode
            #         . (lambda ()
            #             (turn-on-reftex)       ; Hook up AUCTeX with RefTeX.
            #             (auto-fill-mode)
            #             (define-key LaTeX-mode-map [adiaeresis] "\\\"a")))
            #     ''
            #     ];
            #     config = ''
            #     (setq TeX-PDF-mode t
            #             TeX-auto-save t
            #             TeX-parse-self t
            #             TeX-output-view-style '(("^pdf$" "." "evince %o")
            #                                     ( "^ps$" "." "evince %o")
            #                                     ("^dvi$" "." "evince %o")))

            #     ;; Add Glossaries command. See
            #     ;; http://tex.stackexchange.com/a/36914
            #     (eval-after-load "tex"
            #         '(add-to-list
            #         'TeX-command-list
            #         '("Glossaries"
            #             "makeglossaries %s"
            #             TeX-run-command
            #             nil
            #             t
            #             :help "Create glossaries file")))
            #     '';
            # };

            # company-lsp = {
            #     enable = true;
            #     after = [ "company" ];
            #     command = [ "company-lsp" ];
            #     config = ''
            #     (setq company-lsp-enable-snippet t
            #             company-lsp-async t
            #             company-lsp-cache-candidates 'auto)
            #     '';
            # };

            lsp-ui = {
                enable = true;
                command = [ "lsp-ui-mode" ];
                bind = {
                "C-c r d" = "lsp-ui-doc-show";
                "C-c f s" = "lsp-ui-find-workspace-symbol";
                };
                config = ''
                (setq lsp-ui-sideline-enable t
                        lsp-ui-sideline-show-symbol nil
                        lsp-ui-sideline-show-hover nil
                        lsp-ui-sideline-show-code-actions nil
                        lsp-ui-sideline-update-mode 'point
                        lsp-ui-doc-enable nil)
                '';
            };

            lsp-ui-flycheck = {
                enable = true;
                command = [ "lsp-ui-flycheck-enable" ];
                after = [ "flycheck" "lsp-ui" ];
            };

            lsp-mode = {
                enable = true;
                command = [ "lsp" ];
                bind = {
                "C-c r r" = "lsp-rename";
                "C-c r f" = "lsp-format-buffer";
                "C-c r g" = "lsp-format-region";
                "C-c r a" = "lsp-execute-code-action";
                "C-c f r" = "lsp-find-references";
                };
                config = ''
                (setq lsp-eldoc-render-all nil
                        lsp-prefer-flymake nil)
                '';
            };

            # lsp-java = {
            #     enable = true;
            #     hook = [
            #     ''
            #         (java-mode . (lambda ()
            #                     (require 'lsp-java)
            #                     (lsp)))
            #     ''
            #     ];
            #     bindLocal = {
            #     java-mode-map = {
            #         "C-c r o" = "lsp-java-organize-imports";
            #     };
            #     };
            #     config = ''
            #     (setq lsp-java-save-actions-organize-imports nil
            #             lsp-java-completion-favorite-static-members
            #                 '("org.assertj.core.api.Assertions.*"
            #                 "org.assertj.core.api.Assumptions.*"
            #                 "org.hamcrest.Matchers.*"
            #                 "org.junit.Assert.*"
            #                 "org.junit.Assume.*"
            #                 "org.junit.jupiter.api.Assertions.*"
            #                 "org.junit.jupiter.api.Assumptions.*"
            #                 "org.junit.jupiter.api.DynamicContainer.*"
            #                 "org.junit.jupiter.api.DynamicTest.*"))
            #     '';
            # };

            # lsp-rust = {
            #     enable = true;
            #     hook = [
            #     ''
            #         (rust-mode . (lambda ()
            #                     (direnv-update-environment)
            #                     (lsp)))
            #     ''
            #     ];
            # };

            lsp-treemacs = {
                enable = true;
                after = [ "lsp-mode" "treemacs" ];
            };

            dap-mode = {
                enable = true;
                after = [ "lsp-mode" ];
                command = [ "dap-mode" "dap-ui-mode" ];
                config = ''
                (dap-mode t)
                (dap-ui-mode t)
                '';
            };

            # dap-java = {
            #     enable = true;
            #     after = [ "lsp-java" ];
            # };

            # #  Setup RefTeX.
            # reftex = {
            #     enable = true;
            #     defer = true;
            #     config = ''
            #     (setq reftex-default-bibliography '("~/research/bibliographies/main.bib")
            #             reftex-cite-format 'natbib
            #             reftex-plug-into-AUCTeX t)
            #     '';
            # };

            # haskell-mode = {
            #     enable = true;
            #     command = [
            #     "haskell-decl-scan-mode"
            #     "haskell-doc-mode"
            #     "haskell-indentation-mode"
            #     "interactive-haskell-mode"
            #     ];
            #     mode = [
            #     ''("\\.hs\\'" . haskell-mode)''
            #     ''("\\.hsc\\'" . haskell-mode)''
            #     ''("\\.c2hs\\'" . haskell-mode)''
            #     ''("\\.cpphs\\'" . haskell-mode)''
            #     ''("\\.lhs\\'" . literate-haskell-mode)''
            #     ];
            #     hook = [
            #     ''
            #         (haskell-mode
            #         . (lambda ()
            #             (subword-mode +1)
            #             (interactive-haskell-mode +1)
            #             (haskell-doc-mode +1)
            #             (haskell-indentation-mode +1)
            #             (haskell-decl-scan-mode +1)))
            #     ''
            #     ];
            #     bindLocal = {
            #     haskell-mode-map = {
            #         "C-c h i" = "haskell-navigate-imports";
            #         "C-c r o" = "haskell-mode-format-imports";
            #         "C-<right>" = "haskell-move-nested-right";
            #         "C-<left>" = "haskell-move-nested-left";
            #     };
            #     };
            #     config = ''
            #     (require 'haskell)
            #     (require 'haskell-doc)

            #     (setq haskell-process-auto-import-loaded-modules t
            #             haskell-process-suggest-remove-import-lines t
            #             haskell-process-log t
            #             haskell-notify-p t)

            #     (setq haskell-process-args-cabal-repl
            #             '("--ghc-options=+RTS -M500m -RTS -ferror-spans -fshow-loaded-modules"))
            #     '';
            # };

            # haskell-cabal = {
            #     enable = true;
            #     mode = [ ''("\\.cabal\\'" . haskell-cabal-mode)'' ];
            #     bindLocal = {
            #     haskell-cabal-mode-map = {
            #         "C-c C-c" = "haskell-process-cabal-build";
            #         "C-c c" = "haskell-process-cabal";
            #         "C-c C-b" = "haskell-interactive-bring";
            #     };
            #     };
            # };

            markdown-mode = {
                enable = true;
                mode = [
                ''"\\.mdwn\\'"''
                ''"\\.markdown\\'"''
                ''"\\.md\\'"''
                ];
            };

            pandoc-mode = {
                enable = true;
                after = [ "markdown-mode" ];
                hook = [ "markdown-mode" ];
                bindLocal = {
                markdown-mode-map = {
                    "C-c C-c" = "pandoc-run-pandoc";
                };
                };
            };

            nix-mode = {
                enable = true;
                mode = [ ''"\\.nix\\'"'' ];
                hook = [ "(nix-mode . subword-mode)" ];
            };

            # Use ripgrep for fast text search in projects. I usually use
            # this through Projectile.
            ripgrep = {
                enable = true;
                command = [ "ripgrep-regexp" ];
            };

            org = {
                enable = true;
                bind = {
                "C-c c" = "org-capture";
                "C-c a" = "org-agenda";
                "C-c l" = "org-store-link";
                "C-c b" = "org-switchb";
                };
                hook = [
                ''
                    (org-mode
                    . (lambda ()
                        (add-hook 'completion-at-point-functions
                                'pcomplete-completions-at-point nil t)))
                ''
                ];
                config = ''
                ;; Some general stuff.
                (setq org-reverse-note-order t
                        org-use-fast-todo-selection t)

                (setq org-tag-alist rah-org-tag-alist)

                ;; Refiling should include not only the current org buffer but
                ;; also the standard org files. Further, set up the refiling to
                ;; be convenient with IDO. Follows norang's setup quite closely.
                (setq org-refile-targets '((nil :maxlevel . 2)
                                            (org-agenda-files :maxlevel . 2))
                        org-refile-use-outline-path t
                        org-outline-path-complete-in-steps nil
                        org-refile-allow-creating-parent-nodes 'confirm)

                ;; Add some todo keywords.
                (setq org-todo-keywords
                        '((sequence "TODO(t)"
                                    "STARTED(s!)"
                                    "WAITING(w@/!)"
                                    "DELEGATED(@!)"
                                    "|"
                                    "DONE(d!)"
                                    "CANCELED(c@!)")))

                ;; Setup org capture.
                (setq org-default-notes-file (rah-org-file "capture"))

                ;; Active Org-babel languages
                (org-babel-do-load-languages 'org-babel-load-languages
                                            '((plantuml . t)
                                                (http . t)
                                                (shell . t)))

                ;; Unfortunately org-mode tends to take over keybindings that
                ;; start with C-c.
                (unbind-key "C-c SPC" org-mode-map)
                (unbind-key "C-c w" org-mode-map)
                '';
            };

            org-agenda = {
                enable = true;
                after = [ "org" ];
                defer = true;
                config = ''
                ;; Set up agenda view.
                (setq org-agenda-files (rah-all-org-files)
                        org-agenda-span 5
                        org-deadline-warning-days 14
                        org-agenda-show-all-dates t
                        org-agenda-skip-deadline-if-done t
                        org-agenda-skip-scheduled-if-done t
                        org-agenda-start-on-weekday nil)
                '';
            };

            org-mobile = {
                enable = true;
                after = [ "org" ];
                defer = true;
            };

            ob-http = {
                enable = true;
                after = [ "org" ];
                defer = true;
            };

            # ob-plantuml = {
            #     enable = true;
            #     after = [ "org" ];
            #     defer = true;
            # };

            org-table = {
                enable = true;
                after = [ "org" ];
                command = [ "orgtbl-to-generic" ];
                hook = [
                # For orgtbl mode, add a radio table translator function for
                # taking a table to a psql internal variable.
                ''
                    (orgtbl-mode
                    . (lambda ()
                        (defun rah-orgtbl-to-psqlvar (table params)
                        "Converts an org table to an SQL list inside a psql internal variable"
                        (let* ((params2
                                (list
                                    :tstart (concat "\\set " (plist-get params :var-name) " '(")
                                    :tend ")'"
                                    :lstart "("
                                    :lend "),"
                                    :sep ","
                                    :hline ""))
                                (res (orgtbl-to-generic table (org-combine-plists params2 params))))
                            (replace-regexp-in-string ",)'$"
                                                    ")'"
                                                    (replace-regexp-in-string "\n" "" res))))))
                ''
                ];
                config = ''
                (unbind-key "C-c SPC" orgtbl-mode-map)
                (unbind-key "C-c w" orgtbl-mode-map)
                '';
                extraConfig = ''
                :functions org-combine-plists
                '';
            };

            org-capture = {
                enable = true;
                after = [ "org" ];
                config = ''
                (setq org-capture-templates rah-org-capture-templates)
                '';
            };

            org-clock = {
                enable = true;
                after = [ "org" ];
                config = ''
                (setq org-clock-rounding-minutes 5
                        org-clock-out-remove-zero-time-clocks t)
                '';
            };

            org-duration = {
                enable = true;
                after = [ "org" ];
                config = ''
                ;; I always want clock tables and such to be in hours, not days.
                (setq org-duration-format (quote h:mm))
                '';
            };

            org-bullets = {
                enable = true;
                hook = [ "(org-mode . org-bullets-mode)" ];
            };

            org-tree-slide = {
                enable = true;
                command = [ "org-tree-slide-mode" ];
            };

            # # Set up yasnippet. Defer it for a while since I don't generally
            # # need it immediately.
            # yasnippet = {
            #     enable = true;
            #     defer = 1;
            #     diminish = [ "yas-minor-mode" ];
            #     command = [ "yas-global-mode" "yas-minor-mode" ];
            #     hook = [
            #     # Yasnippet interferes with tab completion in ansi-term.
            #     "(term-mode . (lambda () (yas-minor-mode -1)))"
            #     ];
            #     config = "(yas-global-mode 1)";
            # };

            # # Doesn't seem to work, complains about # in go snippets.
            # yasnippet-snippets = {
            #     enable = false;
            #     after = [ "yasnippet" ];
            # };

            # # Setup the cperl-mode, which I prefer over the default Perl
            # # mode.
            # cperl-mode = {
            #     enable = true;
            #     defer = true;
            #     hook = [ "ggtags-mode" ];
            #     command = [ "cperl-set-style" ];
            #     config = ''
            #     ;; Avoid deep indentation when putting function across several
            #     ;; lines.
            #     (setq cperl-indent-parens-as-block t)

            #     ;; Use cperl-mode instead of the default perl-mode
            #     (defalias 'perl-mode 'cperl-mode)
            #     (cperl-set-style "PerlStyle")
            #     '';
            # };

            # Setup ebib, my chosen bibliography manager.
            # ebib = {
            #     enable = true;
            #     command = [ "ebib" ];
            #     hook = [
            #     # Highlighting of trailing whitespace is a bit annoying in ebib.
            #     ''
            #         (ebib-index-mode-hook
            #         . (lambda ()
            #             (setq show-trailing-whitespace nil)))
            #     ''

            #     ''
            #         (ebib-entry-mode-hook
            #         . (lambda ()
            #             (setq show-trailing-whitespace nil)))
            #     ''
            #     ];
            #     config = ''
            #     (setq ebib-latex-preamble '("\\usepackage{a4}"
            #                                 "\\bibliographystyle{amsplain}")
            #             ebib-print-preamble '("\\usepackage{a4}")
            #             ebib-print-tempfile "/tmp/ebib.tex"
            #             ebib-extra-fields '(crossref
            #                                 url
            #                                 annote
            #                                 abstract
            #                                 keywords
            #                                 file
            #                                 timestamp
            #                                 doi))
            #     '';
            # };

            smartparens = {
                enable = true;
                defer = 1;
                diminish = [ "smartparens-mode" ];
                command = [ "smartparens-global-mode" "show-smartparens-global-mode" ];
                bindLocal = {
                smartparens-mode-map = {
                    "C-M-f" = "sp-forward-sexp";
                    "C-M-b" = "sp-backward-sexp";
                };
                };
                config = ''
                (require 'smartparens-config)
                (smartparens-global-mode t)
                (show-smartparens-global-mode t)
                '';
            };

            fill-column-indicator = {
                enable = true;
                command = [ "fci-mode" ];
                defer = 1;
            };

            flycheck = {
                enable = true;
                diminish = [ "flycheck-mode" ];
                command = [ "global-flycheck-mode" ];
                defer = 1;
                config = ''
                ;; Only check buffer when mode is enabled or buffer is saved.
                (setq flycheck-check-syntax-automatically '(mode-enabled save))

                ;; Enable flycheck in all eligible buffers.
                (global-flycheck-mode)
                '';
            };

            # flycheck-haskell = {
            #     enable = true;
            #     hook = [ "(flycheck-mode . flycheck-haskell-setup)" ];
            # };

            # flycheck-plantuml = {
            #     enable = true;
            #     hook = [ "(flycheck-mode . flycheck-plantuml-setup)" ];
            # };

            projectile = {
                enable = true;
                diminish = [ "projectile-mode" ];
                command = [ "projectile-mode" ];
                bindKeyMap = {
                "C-c p" = "projectile-command-map";
                };
                config = ''
                (setq projectile-enable-caching t
                        projectile-completion-system 'ivy)
                (projectile-mode 1)
                '';
            };

            plantuml-mode = {
                enable = true;
                mode = [ ''"\\.puml\\'"'' ];
            };

            ace-window = {
                enable = true;
                extraConfig = ''
                :bind* (("C-c w" . ace-window)
                        ("M-o" . ace-window))
                '';
            };

            company = {
                enable = true;
                diminish = [ "company-mode" ];
                hook = [ "(after-init . global-company-mode)" ];
                extraConfig = ''
                :bind (:map company-mode-map
                            ([remap completion-at-point] . company-complete-common)
                            ([remap complete-symbol] . company-complete-common))
                '';
                config = ''
                (setq company-idle-delay 0.3
                        company-show-numbers t)
                '';
            };

            company-yasnippet = {
                enable = true;
                bind = {
                "M-/" = "company-yasnippet";
                };
            };

            company-dabbrev = {
                enable = true;
                after = [ "company" ];
                command = [ "company-dabbrev" ];
                config = ''
                (setq company-dabbrev-downcase nil
                        company-dabbrev-ignore-case t)
                '';
            };

            company-quickhelp = {
                enable = true;
                after = [ "company" ];
                command = [ "company-quickhelp-mode" ];
                config = ''
                (company-quickhelp-mode 1)
                '';
            };

            company-cabal = {
                enable = true;
                after = [ "company" ];
                command = [ "company-cabal" ];
                config = ''
                (add-to-list 'company-backends 'company-cabal)
                '';
            };

            company-restclient = {
                enable = true;
                after = [ "company" "restclient" ];
                command = [ "company-restclient" ];
                config = ''
                (add-to-list 'company-backends 'company-restclient)
                '';
            };

            # php-mode = {
            #     enable = true;
            #     mode = [ ''"\\.php\\'"'' ];
            #     hook = [ "ggtags-mode" ];
            # };

            # protobuf-mode = {
            #     enable = true;
            #     mode = [ ''"'\\.proto\\'"'' ];
            # };

            python = {
                enable = true;
                mode = [ ''("\\.py\\'" . python-mode)'' ];
                hook = [ "ggtags-mode" ];
            };

            restclient = {
                enable = true;
                mode = [ ''("\\.http\\'" . restclient-mode)'' ];
            };

            transpose-frame = {
                enable = true;
                bind = {
                "C-c f t" = "transpose-frame";
                };
            };

            tt-mode = {
                enable = true;
                mode = [ ''"\\.tt\\'"'' ];
            };

            smart-tabs-mode = {
                enable = false;
                config = ''
                (smart-tabs-insinuate 'c 'c++ 'cperl 'java)
                '';
            };

            octave = {
                enable = true;
                mode = [
                ''("\\.m\\'" . octave-mode)''
                ];
            };

            yaml-mode = {
                enable = true;
                mode = [ ''"\\.yaml\\'"'' ];
            };

            wc-mode = {
                enable = true;
                command = [ "wc-mode" ];
            };

            web-mode = {
                enable = true;
                mode = [
                ''"\\.html\\'"''
                ''"\\.jsx?\\'"''
                ];
                config = ''
                (setq web-mode-attr-indent-offset 4
                        web-mode-code-indent-offset 2
                        web-mode-markup-indent-offset 2)

                (add-to-list 'web-mode-content-types '("jsx" . "\\.jsx?\\'"))
                '';
            };

            dired = {
                enable = true;
                defer = true;
                config = ''
                (put 'dired-find-alternate-file 'disabled nil)
                ;; Use the system trash can.
                (setq delete-by-moving-to-trash t)
                '';
            };

            wdired = {
                enable = true;
                bindLocal = {
                dired-mode-map = {
                    "C-c C-w" = "wdired-change-to-wdired-mode";
                };
                };
                config = ''
                ;; I use wdired quite often and this setting allows editing file
                ;; permissions as well.
                (setq wdired-allow-to-change-permissions t)
                '';
            };

            dired-x = {
                enable = true;
                after = [ "dired" ];
            };

            recentf = {
                enable = true;
                command = [ "recentf-mode" ];
                config = ''
                (setq recentf-save-file (locate-user-emacs-file "recentf")
                        recentf-max-menu-items 20
                        recentf-max-saved-items 500
                        recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG"))
                '';
            };

            # nxml-mode = {
            #     enable = true;
            #     mode = [ ''"\\.xml\\'"'' ];
            #     config = ''
            #     (setq nxml-child-indent 4
            #             nxml-attribute-indent 4
            #             nxml-slash-auto-complete-flag t)
            #     (add-to-list 'rng-schema-locating-files
            #                 "~/.emacs.d/nxml-schemas/schemas.xml")
            #     '';
            # };

            # rust-mode = {
            #     enable = true;
            #     mode = [ ''"\\.rs\\'"'' ];
            # };

            # sendmail = {
            #     enable = false;
            #     mode = [
            #     ''("mutt-" . mail-mode)''
            #     ''("\\.article" . mail-mode))''
            #     ];
            #     hook = [
            #     ''
            #         (lambda ()
            #             (auto-fill-mode)     ; Avoid having to M-q all the time.
            #             (rah-mail-flyspell)  ; I spel funily soemtijms.
            #             (rah-mail-reftex)    ; Make it easy to include references.
            #             (mail-text))         ; Jump to the actual text.
            #     ''
            #     ];
            # };

            # sv-kalender = {
            #     enable = true;
            #     package = epkgs: epkgs.trivialBuild {
            #     pname = "sv-kalender";
            #     version = "0";
            #     src = pkgs.fetchurl {
            #         url = "http://bigwalter.net/daniel/elisp/sv-kalender.el";
            #         sha256 = "0kilp0nyhj67qscy13s0g07kygz2qwmddklhan020sk7z7jv3lpi";
            #         postFetch = ''
            #         sed -i "\$a(provide 'sv-kalender)" $out
            #         '';
            #     };
            #     };
            # };

            systemd = {
                enable = true;
                defer = true;
            };

            treemacs = {
                enable = true;
                bind = {
                "C-c t f" = "treemacs-find-file";
                "C-c t t" = "treemacs";
                };
            };

            treemacs-projectile = {
                enable = true;
                after = [ "treemacs" "projectile" ];
            };
            };
        };


    };
  };
}