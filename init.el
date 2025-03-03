(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq custom-file '"~/.emacs.d/custom.el")
(load-file custom-file)

(set-frame-font "FiraCode Nerd Font Mono 16" nil t)

(global-set-key (kbd "C-;") 'execute-extended-command)
(global-set-key (kbd "C-h") 'backward-char)
(global-set-key (kbd "C-j") 'next-line)
(global-set-key (kbd "C-k") 'previous-line)
(global-set-key (kbd "C-l") 'forward-char)
(global-set-key (kbd "C-p") 'recenter-top-bottom)
(global-set-key (kbd "C-f") 'forward-word)
(global-set-key (kbd "C-b") 'backward-word)
(global-set-key (kbd "C-n") 'scroll-up-command)
(global-set-key (kbd "C-u") 'scroll-down-command)
(global-set-key (kbd "C-v") 'kill-line)

;; Activate auto close parents
(electric-pair-mode t)

;; Display relative column numbers on the left
(setq display-line-numbers 'relative)

;; Remove tool/menu/scroll bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Max column indication
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode)

;; Shortcut to avoid yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; remove tabs indent
(setq-default indent-tabs-mode nil)

;; Enable column number on the bottom bar
(setq column-number-mode t)

;; Custom function that duplicates the current line under the cursor
(defun duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
	(line (let ((s (thing-at-point 'line t)))
		(if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (foward-char column)))

(global-set-key (kbd "C-,") 'duplicate-line)

;; Start of installing packages
(straight-use-package 'use-package)

;; Dark theme
(use-package gruber-darker-theme
  :straight t
  :config
  (load-theme 'gruber-darker t))

;; RFC
(use-package rfc-mode
  :straight t
  :config
  (setq rfc-mode-directory (expand-file-name "~/rfc/"))
  :bind
  ("C-c r" . rfc-mode-browse))

;; Highlight keywords used in comments
(use-package hl-todo
  :straight t
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"  . "#ff0000")
          ("DEBUG" . "#1e90ff")))
  :hook (prog-mode-hook . hl-todo-mode))

;; Rainbow mode
;; Add colors to curly brackets
(use-package rainbow-mode
  :straight t
  :config
  (setq rainbow-ansi-colors nil)
  (setq rainbow-x-colors nil))

;; Search engine
(use-package ido
  :straight t
  :config
  (ido-mode t)
  :bind
  ("C-S-n" . ido-next-match)
  ("C-S-p" . ido-prev-match))
