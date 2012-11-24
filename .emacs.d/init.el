
;; ロードパスの設定
(add-to-list 'load-path "~/.emacs.d/conf")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;; conf ディレクトリ以下のファイルをロード
(dolist (file (directory-files "~/.emacs.d/conf" nil "^[^_][^.]+\\.el$"))
  (load file))

;; 選択されたリージョンに色を付ける
(transient-mark-mode t)

;; カーソル位置を表示
(column-number-mode t)
(line-number-mode t)

;; ツールバー／メニューバーを非表示に
(when window-system
  (tool-bar-mode -1)
  (menu-bar-mode -1))

;; 対応する括弧をハイライト
(show-paren-mode t)
(setq show-paren-style 'expression)

;; linum
(when (<= 23 emacs-major-version)
  (require 'linum)
  (global-linum-mode t)
  (setq linum-format "%5d ")
)

;; auto-install.el
(when nil
    (require 'auto-install)
  (setq auto-install-directory "~/.emacs.d/auto-install/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup)
  )

;; anything : M-x auto-install-batch anything
(when (<= 23 emacs-major-version)
  (require 'anything-startup)
  (global-set-key (kbd "C-t") 'anything)
  )

;; iswitchb-mode
(when (<= emacs-major-version 22)
  (iswitchb-mode t)
  (add-hook 'iswitchb-define-mode-map-hook
	    (lambda ()
	      (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
	      (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
	      (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
	      (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
	      (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
	      (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
	      ))
  )

;; gtags-mode
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
	 (local-set-key "\M-t" 'gtags-find-tag)
	 (local-set-key "\M-r" 'gtags-find-rtag)
	 (local-set-key "\M-s" 'gtags-find-symbol)
	 (local-set-key "\C-t" 'gtags-pop-stack)
	 ))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)
(setq ruby-deep-indent-paren-style nil)

;; Esc :q => exit
(define-prefix-command 'vim-like)
(define-key vim-like "q" 'save-buffers-kill-emacs)
(define-key global-map (kbd "M-:") 'vim-like)

(global-set-key (kbd "C-h") 'delete-backward-char)

;; js-mode
(when (<= 23 emacs-major-version)
  (require 'js)
  (add-hook 'js-mode-hook
	    (lambda ()
	      (setq js-indent-level 2)
	      (setq js-expr-indent-offset 2)
	      (setq c-basic-offset 2)
	      (setq indent-tab-mode nil)
	      ))
  )

;; php-mode http://php-mode.sourceforge.net/
(require 'php-mode)

;; Ricty
(when (and (<= 23 emacs-major-version) window-system)
  (set-face-attribute 'default nil :family "Ricty" :height 160)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Ricty"))
  )






