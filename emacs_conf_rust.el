;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Ensure `use-package` is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Always ensure packages are installed
(setq use-package-always-ensure t)

;; ------------------------
;; Basic UI and Navigation
;; ------------------------

;; Disable toolbar and scrollbar if available
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1)) ;; Disable toolbar

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1)) ;; Disable scrollbar

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Show line numbers
(global-display-line-numbers-mode t)

;; Set font and theme
(set-face-attribute 'default nil :height 120) ;; Adjust font size
(load-theme 'wombat t) ;; Replace with your preferred theme

;; Better file navigation
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "))

;; Helpful for better command explanations
(use-package helpful
  :bind ([remap describe-function] . helpful-callable
         [remap describe-variable] . helpful-variable
         [remap describe-key] . helpful-key))

;; -----------------
;; Rust Development
;; -----------------

;; Install `rustic` for Rust mode
(use-package rustic
  :config
  ;; Use LSP for Rust
  (setq rustic-lsp-client 'lsp-mode
        rustic-format-on-save t) ;; Automatically format on save
  :hook (rust-mode . lsp-deferred))

;; LSP mode for language server features
(use-package lsp-mode
  :commands lsp
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :config
  (setq lsp-prefer-flymake nil)) ;; Use Flycheck instead of Flymake

;; LSP UI for better visual feedback
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))

;; Autocomplete with Company
(use-package company
  :hook (lsp-mode . company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1))

;; Syntax checking with Flycheck
(use-package flycheck
  :init (global-flycheck-mode))

;; Debugging support with DAP
(use-package dap-mode
  :after lsp-mode
  :config
  (dap-ui-mode 1)
  (require 'dap-lldb)
  (setq dap-lldb-debug-program '("lldb-vscode"))
  (dap-register-debug-template "Rust::LLDB"
                               (list :type "lldb"
                                     :request "launch"
                                     :name "Rust::LLDB"
                                     :gdbpath "rust-lldb"
                                     :target nil
                                     :cwd nil)))

;; ------------------------
;; Git Integration
;; ------------------------

;; Magit for Git version control
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

;; Show inline diffs with diff-hl
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (after-save . diff-hl-update))
  :config
  (global-diff-hl-mode))

;; Git Timemachine for file history navigation
(use-package git-timemachine
  :bind (("C-x v t" . git-timemachine)))

;; Project management with Projectile
(use-package projectile
  :hook (prog-mode . projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-completion-system 'ivy
        projectile-enable-caching t))

;; ------------------------
;; Utilities and Shortcuts
;; ------------------------

;; Ripgrep for searching within projects
(use-package ripgrep
  :bind (("C-c r" . ripgrep-regexp)))

;; Keybindings for navigation
(global-set-key (kbd "M-.") 'xref-find-definitions) ;; Jump to definition
(global-set-key (kbd "M-,") 'xref-pop-marker-stack) ;; Jump back
(global-set-key (kbd "C-M-i") 'company-complete)    ;; Trigger autocomplete

;; Enable Treemacs for project structure
(use-package treemacs
  :bind ("C-x t" . treemacs))

;; Save Emacs session
(desktop-save-mode 1)

;; ----------------------
;; End of Configuration
;; ----------------------
