(setq lexical-binding t)
;; Turn off mouse interface early in startup to avoid momentary display
;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Delete text in active region before inserting new one
(delete-selection-mode 1)

;; NO TABS
(setq-default indent-tabs-mode nil)

(package-initialize)

;; Quelpa, package manager
(if (require 'quelpa nil t)
    (quelpa '(quelpa :repo "quelpa/quelpa" :fetcher github))
  (with-temp-buffer
    (url-insert-file-contents "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")
    (eval-buffer)))
(require 'help-fns)  ; quelpa needs it for tar archives

;; iswitch
(iswitchb-mode 1)

;; Colors
(quelpa '(molokai-theme :repo "hbin/molokai-theme" :fetcher github))
(load-theme 'molokai t)

(show-paren-mode 1)

(quelpa 'nyan-mode)
(nyan-mode)
(nyan-start-animation)

(setq show-trailing-whitespace t)

(quelpa 'smart-mode-line)
(setq sml/theme 'dark)
(sml/setup)

;; Simple editing bindings
(global-set-key (kbd "C-h") (kbd "<backspace>"))
(global-set-key (kbd "C-x C-j") 'join-next-line)
(defun join-next-line ()
  (interactive)
  (join-line 1))

;; Expand region
(quelpa 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Multiple cursors
(quelpa 'multiple-cursors)
(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
(define-key mc/keymap (kbd "<return>") nil)

;; Phi-search, i-search that works with multiple-cursors.el
(quelpa 'phi-search)
(quelpa 'phi-search-mc)
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)
; changes mc/mark-{next,previous,all}-like-this to phi-compatible versions
; inside the phi-search buffer
(phi-search-mc/setup-keys)


;; other modes
(quelpa 'flycheck)
(global-flycheck-mode 1)

(quelpa 'undo-tree)
(global-undo-tree-mode)

(quelpa 'diff-hl)
(global-diff-hl-mode 1)
; TODO: zmusić go do działania z niezapisanym plikiem?

;;;;;;;;;;
;; Magit
(quelpa 'magit)
(require 'magit)

;;;;;;;;;;;
;; Python
(quelpa 'elpy)
(elpy-enable)
; don't start flymake - we have global flycheck anyway
(add-hook 'elpy-mode-hook
  (lambda ()
    (setq elpy-default-minor-mode (delete 'flymake-mode elpy-default-minor-mode))))

;;;;;;;;;;
;; YAML
(quelpa '(yaml-mode :repo "yoshiki/yaml-mode" :fetcher github))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;;;;;;;;;;;;;;;;;;;;;;
;; File buffer utils ;;
;;;;;;;;;;;;;;;;;;;;;;;
(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                    (file-name-nondirectory new-name)))))))

;;;;;;;;;;;
;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("9fd20670758db15cc4d0b4442a74543888d2e445646b25f2755c65dcd6f1504b" default)))
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(uniquify-trailing-separator-p t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))
