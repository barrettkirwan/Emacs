  (add-to-list 'load-path "/apollo/env/EmacsAmazonLibs/share/emacs/site-lisp")
  (require 'amz-common)
  (setq debug-on-error t)
  (setq global-auto-revert-mode t)
  (global-git-commit-mode t)
  (setq fill-column 68)
  ;; HOOKS
  (add-hook 'ado-mode-hook 'evil-cleverparens-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  '(version-control :variables
                    version-control-diff-tool 'diff-hl)
  '(version-control :variables
                    version-control-global-margin t)
  (add-hook 'message-mode-hook 'orgstruct++-mode 'append)
  (add-hook 'message-mode-hook 'orgtbl-mode 'append)
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  ;; Define functions
  ;; http://oremacs.com/2014/12/23/upcase-word-you-silly/
  (defadvice upcase-word (before upcase-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word)))

  (defadvice downcase-word (before downcase-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word)))

  (defadvice capitalize-word (before capitalize-word-advice activate)
    (unless (looking-back "\\b")
      (backward-word)))
  (setq projectile-tags-command "ctags --exclude=periphlib --exclude=build -Re -f \"%s\" %s")
  ;; Keep track of when a file was last saved
  (setq
   time-stamp-active t ; do enable time-stamps
   time-stamp-line-limit 10 ; check first 10 buffer lines for Time-stamp: <>
   time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)") ; date format
  (add-hook 'write-file-hooks 'time-stamp) ; update when saving
    ;; Keep track of when a file was last saved
  (setq
   time-stamp-active t ; do enable time-stamps
   time-stamp-line-limit 10 ; check first 10 buffer lines for Time-stamp: <>
   time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)") ; date format
  (add-hook 'write-file-hooks 'time-stamp) ; update when saving
  ;; HELM
  ;; http://oremacs.com/2014/12/21/helm-backspace/
  (defun helm-backspace ()
    "Forward to `backward-delete-char'.
On error (read-only), quit without selecting."
    (interactive)
    (condition-case nil
        (backward-delete-char 1)
      (error
       (helm-keyboard-quit))))
  ;; (define-key helm-map (kbd "DEL") 'helm-backspace)
  ;; UNFILL PARAGRAPH
  ;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
  (defun unfill-paragraph ()
    "Takes a multi-line paragraph and makes it into a single line of text."
    (interactive)
    (let ((fill-column (point-max)))
      (fill-paragraph nil)))
  (define-key global-map "\M-p" 'unfill-paragraph)
  ;; UNFILL REGION
  (defun unfill-region (beg end)
    "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
    (interactive "*r")
    (let ((fill-column (point-max)))
      (fill-region beg end)))
  (define-key global-map "\C-c u" 'unfill-region)
    ;; SET PARAMETERS
  ;; The following come from http://oremacs.com/2015/01/21/dired-shortcuts/
  (setq dired-garbage-files-regexp
        "\\.idx\\|\\.run\\.xml$\\|\\.bbl$\\|\\.bcf$\\|.blg$\\|-blx.bib$\\|.nav$\\|.snm$\\|.out$\\|.synctex.gz$\\|\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|pyg\\)\\)\\'")
  (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
  (setq dired-omit-files "\\(?:.*\\.\\(?:aux\\|log\\|synctex\\.gz\\|run\\.xml\\|bcf\\|am\\|in\\)\\'\\)\\|^\\.\\|-blx\\.bib")
  ;; WDIRED
  ;; wdired makes the dired buffer writeable--it is built into emacs
  ;; - =dired-toggle-read-only, C-x C-q= :: cycle between dired-mode and wdired-mode
  ;; - =wdired-finish-edit, C-c C-c= :: commit your changes
  ;; - =wdired-abort-changes, C-c ESC= :: revert your changes
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-allow-to-redirect-links t)
  (setq wdired-use-interactive-rename +1)
  (setq wdired-confirm-overwrite +1)
  (setq wdired-use-dired-vertical-movement 'sometimes)
    ;; KEY BINDINGS
  (global-set-key (kbd "C-x r M-w") 'my-copy-rectangle)
  (global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two
  ;; Add keybindings for commenting regions of text
  (global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
  (global-set-key (kbd "M-'") 'comment-or-uncomment-region)
  ;; Align your code in a pretty way.
  (global-set-key (kbd "C-x \\") 'align-regexp)
  ;; Font size
  (global-set-key (kbd "C-+") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  ;; Window switching. (C-x o goes to the next window)
  (global-set-key (kbd "C-x O") (lambda ()
                                  (interactive)
                                  (other-window -1))) ;; back one
  ;; Start proced in a similar manner to dired
  ;; (unless (eq system-type 'darwin)
  ;; (global-set-key (kbd "C-x p") 'proced))
  ;; Start eshell or switch to it if it's active.
  (global-set-key (kbd "C-x m") 'eshell)
  ;; Start a new eshell even if one is active.
  (global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))
  ;; Start a regular shell if you prefer that.
  ;; (global-set-key (kbd "C-x M-m") 'shell)
  ;; If you want to be able to M-x without meta
  ;; (global-set-key (kbd "C-x C-m") 'smex)
  ;; A complementary binding to the apropos-command (C-h a)
  (define-key 'help-command "A" 'apropos)
  ;; A quick major mode help with discover-my-major
  (define-key 'help-command (kbd "C-m") 'discover-my-major)
  (define-key 'help-command (kbd "C-f") 'find-function)
  (define-key 'help-command (kbd "C-k") 'find-function-on-key)
  (define-key 'help-command (kbd "C-v") 'find-variable)
  (define-key 'help-command (kbd "C-l") 'find-library)
  (define-key 'help-command (kbd "C-i") 'info-display-manual)
  ;; replace zap-to-char functionaity with the more powerful zop-to-char
  (global-set-key (kbd "M-z") 'zop-up-to-char)
  (global-set-key (kbd "M-Z") 'zop-to-char)
  ;; kill lines backward
  (global-set-key (kbd "C-<backspace>") (lambda ()
                                          (interactive)
                                          (kill-line 0)
                                          (indent-according-to-mode)))
  ;; use hippie-expand instead of dabbrev
  (global-set-key (kbd "M-/") 'hippie-expand)
  ;; replace buffer-menu with ibuffer
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  ;; toggle menu-bar visibility
  (global-set-key (kbd "<f12>") 'menu-bar-mode)
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

  (spacemacs/set-leader-keys "oc" 'org-capture)
  (spacemacs/set-leader-keys "orl" 'org-ref-helm-insert-ref-link)
)
