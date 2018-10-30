(require 'gnus)
(require 'smtpmail)
(require 'bbdb)
;; nnir is used to search Gmail
(require 'nnir)
(require 'starttls)
(setq debug-on-error t)
(setq nnml-directory "~/Mail")
(setq message-directory "~/Mail")
(load-library "smtpmail")
(load-library "nnimap")
(load-library "starttls")

(setq imap-enable-exchange-bug-workaround t)
;; From https://blogs.fsfe.org/jens.lechtenboerger/2014/03/23/certificate-pinning-for-gnu-emacs/
;; (if (fboundp 'gnutls-available-p)
;;     (fmakunbound 'gnutls-available-p))
(setq tls-program '("gnutls-cli --strict-tofu -p %p %h")
      imap-ssl-program '("gnutls-cli --strict-tofu -p %p %s")
      smtpmail-stream-type 'starttls
      starttls-extra-arguments '("--strict-tofu")
      )
(setq gnus-select-method
      '(nnimap "bob"
               (nnimap-address "ballard.bob.com")
               (nnimap-stream ssl)
               (nnimap-server-port 1993)
               (nnimap-authinfo-file "~/.authinfo.gpg")))
;; This avoids printing nnimap:exchange in front of every group name.
(setq gnus-group-line-format "%M%S%p%5y:%B%(%G%)%O
")
;; (add-to-list 'gnus-secondary-select-methods '(nntp "news.gnus.org"))
;; (add-to-list 'gnus-secondary-select-methods '(nntp "news.gmane.org"))


(setq gnus-verbose 9)
(setq nnimap-record-commands t)

(setq nnimap-fetch-partial-articles "text/")

(setq message-from-style 'angles)

(setq gnus-signature-file "~/.signature")

;; send mail
(require 'cl)
(setq message-send-mail-function 'smtpmail-send-it)
(setq send-mail-function 'smtpmail-send-it)

(setq user-mail-address "bkirwan@bob.com"
       user-full-name "Barrett Kirwan"
       smtpmail-smtp-server "smtp.bob.com"
       smtpmail-default-smtp-server "smtp.bob.com"
       smtpmail-smtp-service 25
       smtpmail-local-domain "bob.com"
       smtpmail-starttls-credentials ".authinfo.gpg")
(setq smtpmail-debug-info t)
(setq smtpmail-debug-verb t)
;; NB: ballard.bob.com 1578 didn't work for me for smtp, so I used smtp.bob.com 25

;; Use a second connection to grab the next article when I read one, so
;; I don't have to wait for it be downloaded.
(setq gnus-asynchronous t)
(setq gnus-auto-center-summary nil)
;; Turn on the cache so I can keep important articles locally
(setq gnus-use-cache nil)
;; This (should) ignore mail I send
(setq gnus-ignored-from-addresses
      "bkirwan@bob.com")
(setq gnus-extra-headers
      '(Content-Type To Newsgroup))
(setq nnmail-extra-headers gnus-extra-headers)

;; Turn off gnus agent. It's up to no good
(setq gnus-agent nil)
(setq gnus-agent-cache nil)
;; REGISTRY
;;; Turn on the Gnus registry so I can add Keywords and abritrary data
;; to emails
(setq gnus-registry-max-entries 500000
      gnus-registry-use-long-group-names t)
(gnus-registry-initialize)
(setq gnus-refer-article-method
      '(current
        (nnregistry)))
;; show the marks as single characters (see the :char property in
;; `gnus-registry-marks'):
;; WINDOWS CONFIGURATION
(gnus-add-configuration
 '(article
   (horizontal 1.0
               (vertical 30
                         (group 1.0))
               (vertical 1.0
                         (horizontal 1.0
                                     (vertical 0.50
                                               (summary 1.0 point))
                                     (vertical 1.0
                                               (article 1.0)))))))
(gnus-add-configuration
 '(summary
   (horizontal 1.0
               (vertical 30
                         (group 1.0))
               (vertical 1.0
                         (summary 1.0 point)))))

;; GROUP SETTINGS
;; Using %G (default is %g) avoids the nnfoo:bar+ prefix
(setq gnus-group-line-format "%M\%S\%p\%5y: %G\n")
;; Set the Gnus level variables (some of them)
(setq gnus-group-default-list-level 5)
(setq gnus-activate-level 5)
;; (setq gnus-group-list-all-groups 5)
(add-hook 'gnus-group-mode-hook 'gnus-group-sort-groups-by-rank)
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
;; Save time on startup and exit by not checking for new newgroups (i.e. folders on nnimap)
(setq gnus-check-new-newsgroups nil)
(setq gnus-save-killed-list nil)
(setq gnus-read-active-file t)
;; Keep track of when each group is accessed
;; SUMMARY SETTINGS
;; Sort first by name, then by rank (level + score)
;; Note adding two separate hooks does not work.
;; Also, gnus-group-prepare-hook cannot be used for this.
;; Note that topic-mode should run first, therefore added last.
;; https://groups.google.com/forum/#!topic/gnu.emacs.gnus/pnOnQ1bnFB8
;;; threading
;; `N'
;; Article number.
;; `U'
;; Unread.  *Note Read Articles::.
;; `R'
;; This misleadingly named specifier is the "secondary mark".  This
;; mark will say whether the article has been replied to, has been
;; cached, or has been saved.  *Note Other Marks::.
;; `z'
;; Zcore, `+' if above the default level and `-' if below the default
;; level.  If the difference between `gnus-summary-default-score' and
;; the score is less than `gnus-summary-zcore-fuzz', this spec will
;; not be used.
;; `d'
;; The `Date' in `DD-MMM' format.
;; `u'
;; User defined specifier.  The next character in the format string
;; should be a letter.  Gnus will call the function
;; `gnus-user-format-function-X', where X is the letter following
;; `%u'.  The function will be passed the current header as argument.
;; The function should return a string, which will be inserted into
;; the summary just like information from any other summary specifier.
;; `k'
;; Pretty-printed version of the number of characters in the article;
;; for example, `1.2k' or `0.4M'.
;; `B'
;; A complex trn-style thread tree, showing response-connecting trace
;; lines.
;; `s'
;; Subject if the article is the root of the thread or the previous
;; article had a different subject, `gnus-summary-same-subject'
;; otherwise.  (`gnus-summary-same-subject' defaults to `""'.)

(setq gnus-face-9 'font-lock-warning-face)
(setq gnus-face-10 'shadow)
(defun sdl-gnus-summary-line-format-ascii nil
  (interactive)
  (setq gnus-summary-line-format
        (concat
         "%0{%U%R%z%}" "%10{|%}" "%*" "%1{%d%}" "%10{|%}"
         "%9{%u&@;%*%}" "%(%-25,25f %)" "%10{|%}"
         "%5N" "%10{|%}" "%4k" "%10{|%}"
         "%2u&score;" "%O" "%10{|%}" "%10{%B%}" "%s\n"))
  (setq
   gnus-sum-thread-tree-single-indent   "o "
   gnus-sum-thread-tree-false-root      "x "
   gnus-sum-thread-tree-root            "* "
   gnus-sum-thread-tree-vertical        "| "
   gnus-sum-thread-tree-leaf-with-other "|-> "
   gnus-sum-thread-tree-single-leaf     "+-> " ;; "\\" is _one_ char
   gnus-sum-thread-tree-indent          "  ")
  (gnus-message 5 "Using ascii tree layout."))

(defun sdl-gnus-summary-line-format-unicode nil
  (interactive)
  (setq gnus-summary-line-format
        (concat
         "%0{%U%R%z%}" "%10{│%}" "%*" "%1{%d%}" "%10{│%}"
         "%9{%u&@;%*%}" "%(%-25,25f %)" "%10{│%}"
         "%5N" "%10{|%}" "%4k" "%10{│%}"
         "%2u&score;" "%O" "%10{│%}" "%10{%B%}" "%s\n"))
  (setq
   gnus-sum-thread-tree-single-indent   "◎ "
   gnus-sum-thread-tree-false-root      "  "
   gnus-sum-thread-tree-root            "┌ "
   gnus-sum-thread-tree-vertical        "│"
   gnus-sum-thread-tree-leaf-with-other "├─>"
   gnus-sum-thread-tree-single-leaf     "└─>"
   gnus-sum-thread-tree-indent          "  ")
  (gnus-message 5 "Using ascii tree layout with unicode chars."))

(sdl-gnus-summary-line-format-unicode)

(defun gnus-user-format-function-@ (header)
  "Display @ for message with attachment in summary line.
You need to add `Content-Type' to `nnmail-etra-headers' and
`gnus-extra-headers', see Info node `(gnus)To From Newsgroups'."
  (let ((case-fold-search t)
        (ctype (or (cdr (assq 'Content-Type (mail-header-extra header)))
                   "text/plain"))
        indicator)
    (when (string-match "^multipart/mixed" ctype)
      (setq indicator "@"))
    (if indicator
        indicator
      " ")))

(defalias 'gnus-user-format-function-score 'rs-gnus-summary-line-score)

(defun rs-gnus-summary-line-score (head)
  "Return pretty-printed version of article score.
See (info \"(gnus)Group Line Specification\")."
  (let ((c (gnus-summary-article-score (mail-header-number head))))
    ;; (gnus-message 9 "c=%s chars in article %s" c (mail-header-number head))
    (cond ((< c -1000)     "vv")
          ((< c  -100)     " v")
          ((< c   -10)     "--")
          ((< c     0)     " -")
          ((= c     0)     "  ")
          ((< c    10)     " +")
          ((< c   100)     "++")
          ((< c  1000)     " ^")
          (t               "^^"))))

;; The next three lines of code came from here: http://gertm.blogspot.com/2009/06/my-little-gnus-and-gmail-howto.html

;; Threads are nice!
(setq gnus-summary-thread-gathering-function
      'gnus-gather-threads-by-subject)
(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-most-recent-number
        gnus-thread-sort-by-date))

;; From: http://blog.binchen.org/?p=403
;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first
;; message.  'gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Turn off auto expire and expire by hand
(remove-hook 'gnus-summary-prepare-exit-hook
             'gnus-summary-expire-articles)
;; From http://blogs.openaether.org/?p=117
(setq nnmail-expiry-wait 14)
(remove-hook `gnus-mark-article-hook `gnus-summary-mark-read-and-unread-as-read)
(add-hook `gnus-mark-article-hook `gnus-summary-mark-unread-as-read)
;; Remap the d key to delete
(define-key gnus-summary-mode-map "d" 'gnus-summary-mark-as-expirable)
;; Move to next article after tick (instead of next unread article)
(add-hook 'gnus-summary-mode-hook 'my-alter-summary-map)
(defun my-alter-summary-map ()
  (local-set-key "!" 'gnus-summary-put-mark-as-ticked-next)
  (local-set-key "o" 'gnus-summary-insert-old-articles))
;; Adaptive Scoring
;; From http://sachachua.com/notebook/wickedcool/wc-emacs-05-gnus.html
(setq gnus-use-adaptive-scoring t)
(setq gnus-default-adaptive-score-alist
      '((gnus-unread-mark)
        (gnus-ticked-mark (subject 100))
        (gnus-read-mark (subject 10))
        (gnus-killed-mark (subject -5))
        (gnus-catchup-mark (subject -1))))

;; Number of days before temporary scoring rules are deleted
(setq gnus-score-expiry-days 30)

;; MESSAGE SETTINGS
;;; You need install the ClI brower 'w3m' and Emacs plugin 'w3m'
;; (setq mm-text-html-renderer 'w3m)
;;; emacs can display inline images, so don't treat them as attachment
;; Inline images?
(setq mm-attachment-override-types '("image/.*"))
;; Deal with html mail
;; http://www.gnus.org/manual/gnus_398.html#SEC461
(eval-after-load "mm-decode"
  '(progn
     (add-to-list 'mm-discouraged-alternatives "text/html")
     (add-to-list 'mm-discouraged-alternatives "text/richtext")))

;; Use undoc.el to extract the text from MS Word files
(setq mm-inline-media-tests (cons
                             (list "application/.*msword"
                                   'mm-display-msword-inline
                                   (lambda (handle) t))
                             mm-inline-media-tests)
      mm-inlined-types      (cons "application/.*msword" mm-inlined-types))
(defun mm-display-msword-inline (handle)
  (let (text)
    (with-temp-buffer
      (mm-insert-part handle)
      (save-window-excursion
        (undoc-current-buffer)
        (setq text (buffer-string))))
    (mm-insert-inline handle text)))
;; Open MS Word docs inline automatically
;; This seems redundant???
(add-to-list 'mm-inline-media-tests
             '("application/msword" mm-inline-text identity))
(add-to-list 'mm-automatic-external-display "application/msword")
(add-to-list 'mm-attachment-override-types "application/msword")
(add-to-list 'mm-automatic-display "application/msword")

;; This marks mail I send as read.
(setq gnus-gcc-mark-as-read t)
;; Check spelling on the fly
(add-hook 'message-mode-hook (lambda () (flyspell-mode 1)))
                                        ; Gnus is setting @gmail.com as the Message-ID suffix for all email, even from @illinois.edu
;; The following code comes from the Gnus FAQ 5.13
;; It removes the Gnus-generated message id
(setq message-required-mail-headers
      (remove' Message-ID message-required-mail-headers))

(defun cjb-add-formalities ()
  "Add the sender's first name and my tag to e-mail."
  ;; Modified from <http://www.repose.cx/conf/.elisp/de-gnus.el>
  (save-excursion
    (message-goto-signature)
    (previous-line 2)
    (when (not (looking-at "Sincerely,\nBarrett"))
      (insert "\n\nSincerely,\nBarrett")))

  (let* ((to (message-fetch-field "To"))
         (address-comp (mail-extract-address-components to))
         (name (car address-comp))
         (first (or (and name (concat "" (car (split-string name)))) "")))

    (when first
      ;; Go to the first line of the message body.
      (message-goto-body)
      (insert (concat "Hi " (capitalize first) ",\n\n"))
      )))

;; Add formalities for me.
(defadvice gnus-summary-reply (after formalities () activate)
  (cjb-add-formalities))

(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "On %a, %b %d %Y at %r, %f wrote:")

;; Avoid "Here's an attachment oops I forget to attach it augh" embarrassment.
;; Taken from <http://ww.telent.net/diary/2003/1/>.
(defun check-attachments-attached ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let* (
           ;; Nil when message came from outside (eg calling emacs as editor)
           ;; Non-nil marker of end of headers.
           (internal-messagep
            (re-search-forward
             (concat "^" (regexp-quote mail-header-separator) "$") nil t))
           (end-of-headers              ; Start of body.
            (copy-marker
             (or internal-messagep
                 (re-search-forward "^$" nil t)
                 (point-min))))
           (limit
            (or (re-search-forward "^-- $" nil t)
                (point-max)))
           (old-case-fold-search case-fold-search))
      (unwind-protect
          (progn
            (goto-char end-of-headers)
            (when (search-forward "attach" limit t)
              (goto-char end-of-headers)
              ;; the word 'attach' has been used, can we find an
              ;; attachment?
              (unless
                  (or (re-search-forward "^<#/" limit t)
                      (y-or-n-p
                       "Found the word `attach' but no MIME attachment: send anyway? "
                       )
                      (error "Aborted send")))))
        (set-marker end-of-headers nil)))))

(add-hook 'message-send-hook 'check-attachments-attached)

;; file where things will be saved
(setq bbdb-file "~/.emacs.d/savefile/bbdb")

;; load bbdb
;; (require 'bbdb-loaddefs)
(require 'bbdb)
;; initialization
(bbdb-initialize 'gnus 'message)
(bbdb-mua-auto-update-init 'gnus 'message)
;; What do we do when invoking bbdb interactively
(setq bbdb-mua-update-interactive-p '(query . create))
(setq bbdb-mua-auto-update-p 'update)
;; Make sure we look at every address in a message and not only the
;; first one
(setq bbdb-message-all-addresses t)
;; use ; on a message to invoke bbdb interactively
(add-hook
 'gnus-summary-mode-hook
 (lambda ()
   (define-key gnus-summary-mode-map (kbd ";") 'bbdb-mua-edit-field)
   ))
(setq bbdb/send-prompt-for-create-p t)
;; size of the bbdb popup
(setq bbdb-mua-pop-up t)
(setq bbdb-pop-up-window-size 10)
(setq strip-signature t)
;; Tell bbdb about my email address:
;; Deprecated
(setq bbdb-user-mail-names
      (regexp-opt '("bekirwan@gmail.com"
                    "bkirwan@illinois.edu")))
(add-hook 'mail-setup-hook 'bbdb-mail-aliases)
(add-hook 'message-setup-hook 'bbdb-mail-aliases)
(setq
 bbdb-mua-pop-up-window-size 2
 bbdb-complete-mail t
 bbdb-complete-mail-allow-cycling t       ;; cycle through matches
 )
