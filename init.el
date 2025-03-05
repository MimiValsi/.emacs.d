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

;; Set font style and size
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
(global-set-key (kbd "C-d") 'kill-line)
(global-set-key (kbd "C-v") 'delete-char)
(global-set-key (kbd "C-'") 'dired)
(global-set-key (kbd "C-:") 'restart-emacs)
(global-set-key (kbd "M-]") 'forward-paragraph)
(global-set-key (kbd "M-[") 'backward-paragraph)
(global-set-key (kbd "M-l") 'goto-line)

;; Activate auto close parents
(electric-pair-mode t)

;; Display relative column numbers on the left
(global-display-line-numbers-mode)

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

(use-package eglot
  :straight t)

(use-package go-mode
  :straight t
  :hook (go-mode . eglot-ensure))

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
  :init
  (ido-mode t)
  :bind
  ("C-S-n" . ido-next-match)
  ("C-S-p" . ido-prev-match))

;; Multiple-cursos
;; TODO Change keybindings for moonlander kbd
(use-package multiple-cursors
  :straight t
  :bind
  ("C-S-c C-S-c" . 'mc/edit-line)
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this))

(use-package magit
  :straight t
  :config
  (setq magit-log-margin '(t "%F %R" magit-log-margin-width t 18))
  :bind
  ("C-c g" . magit-status))

 ;; ---------- Open GNUS (email) ----------
 (global-set-key (kbd "C-c m") 'gnus)

 (setq gnus-use-full-window nil)
 (setq gnus-summary-line-format
       (concat "%U%R %~(max-right 17)~(pad-right 17)&user-date;  "
               "%~(max-right 20)~(pad-right 20)f %B%s\n"))

 (setq gnus-user-date-format-alist '((t . "%d.%m.%Y %H:%M"))
       gnus-sum-thread-tree-false-root ""
       gnus-sum-thread-tree-indent " "
       gnus-sum-thread-tree-root ""
       gnus-sum-thread-tree-leaf-with-other "├─≻"
       gnus-sum-thread-tree-single-leaf     "└─≻"
       gnus-sum-thread-tree-vertical        "│")

 (setq gnus-summary-thread-gathering-function
       'gnus-gather-threads-by-subject)

 (setq gnus-thread-sort-functions
       '(gnus-thread-sort-by-number
         gnus-thread-sort-by-total-score))

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(setq user-mail-address "miguel@dasilvaf.net")
(setq user-full-name "Miguel Da Silva Ferreira")
(setq message-kill-buffer-on-exit t)

;; Config and receive emails
(setq gnus-select-method
        '(nnimap "miguel@dasilvaf.net"
                (nnimap-address "mail1.netim.hosting")
                (nnimap-server-port 993)
                (nnimap-stream ssl)
                (nnir-search-engine imap)
                (nnimap-inbox "Inbox")
                (nnmail-expiry-target
                 "nnimap+foo:Trash")
                (nnmail-expiry-wait immediate)))

;; Send emails
(setq smtpmail-smtp-server "mail1.netim.hosting")
(setq smtpmail-stream-type 'starttls)
(setq smtpmail-smtp-service 465)
(setq smtpmail-retries 7)
(setq smtpmail-queue-mail nil)
(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)

;; TODO Figure out why Gnus doesn't recognize the signature section!
;; Signature
;;(setq gnus-posting-styles
;;      '((".*"
;;         (address "Miguel Da Silva Ferreira <miguel@dasilvaf.net>")
;;         (signature
;;          "Miguel Da Silva Ferreira")
;;         ("X-Message-SMTP-Method"
;;          "smtp mail1.netim.hosting 465 miguel@dasilvaf.net"))))

;; Contacts
;;(use-package bbdb
;;  :straight t
;;  :init
;;  (bbdb-initialize 'gnus)
;;  (bbdb-initialize 'message)
;;  :config
;;  (setq bbdb-offer-save 1) ; save without asking
;;  (setq bbdb-use-pop-up t) ; allow popups for addresses
;;  (setq bbdb-electric-p t) ; be disposable with SPC
;;  (setq bbdb-popup-target-lines 1) ; very small popup
;;  (setq bbdb-dwim-net-address-allow-redundancy t) ; always use full name
;;  (setq bbdb-quiet-about-name-mismatches 2) ; show name-mismacthes 2 secs
;;  (setq bbdb-always-add-address t)
;;  (setq bbdb-file "~/.bbdb"))

;; Package to read EPUB
(use-package nov
  :straight t)

;; Simpc-mode from Tsoding

;; Adding `/path/to/simpc` to load-path so `require` can find it
(add-to-list 'load-path "~/.emacs.d/custom_packages/simpc-mode")
;; Importing simpc-mode
(require 'simpc-mode)
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
