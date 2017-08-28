;; Allow AucTeX to use biber as well as/instead of bibtex.
;; Biber under AUCTeX
(defun TeX-run-Biber (name command file)
  "Create a process for NAME using COMMAND to format FILE with Biber."
  (let ((process (TeX-run-command name command file)))
    (setq TeX-sentinel-function 'TeX-Biber-sentinel)
    (if TeX-process-asynchronous
        process
      (TeX-synchronous-sentinel name file process))))

;; turn off the default toc behavior; deal with it properly in headers to files.
(defun org-latex-no-toc (depth)
  (when depth
    (format "%% Org-mode is exporting headings to %s levels.\n"
            depth)))
(setq-default TeX-master t)
;; set XeTeX mode in TeX/LaTeX
(add-hook 'LaTeX-mode-hook
          (lambda()
            (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
            (setq TeX-command-default "XeLaTeX")
            (setq TeX-save-query nil)
            (setq TeX-show-compilation t)))
(setq-default TeX-engine 'xetex)
(setq-default TeX-PDF-mode t)
;; sensible defaults for OS X, other OSes should be covered out-of-the-box
(when (eq system-type 'darwin)
  (setq TeX-view-program-selection
        '((output-dvi "DVI Viewer")
          (output-pdf "PDF Viewer")
          (output-html "HTML Viewer")))

  (setq TeX-view-program-list
        '(("DVI Viewer" "open %o")
          ("HTML Viewer" "open %o"))))

;; (add-hook 'TeX-mode-hook
;;           (lambda ()
;;             (add-to-list 'TeX-output-view-style
;;                          '("^pdf$" "."
;;                            "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
;;           )
;; (setq TeX-view-program-list
;;       '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(turn-on-auto-fill)
(abbrev-mode +1)

;;; BIBER
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list '("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber"))
  )

;; REFTEX
;; So that RefTeX finds my bibliography
(setq reftex-default-bibliography '("/path-to-your-default-bibliography"))
;; So that RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

;; ORG EXPORT TO LATEX
(setq org-latex-toccommand 'org-latex-no-toc)

(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("memarticle"
               "\\documentclass\[11pt,oneside,article\]{memoir}\n\\input{vc} % vc package"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("BKbeamer"
               "\\documentclass[presentation,bigger]{beamer}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;; (setq org-latex-default-packages-alist
;;       '(("" "inputenc")
;;         ("" "ulem")
;;         ("" "amsmath")
;;         ("" "amssymb")
;;         ("" "graphicx" t)
;;         ("" "longtable" nil)
;;         ("" "float" )
;;         ("" "url")
;;         ("" "rotating")
;;         ("" "verbatim")
;;         ("" "booktabs")
;;         ("" "tabularx")))

;; (setq org-latex-packages-alist
;;       '(("" "org-preamble-xelatex" t)))
