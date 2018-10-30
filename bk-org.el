(with-eval-after-load 'org
  (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
  (require 'org-ref)
  (require 'org-toodledo)
  (require 'org-inlinetask)
  (require 'org-crypt)
  (require 'org2blog)
  (require 'org-mime)
  (setq org-mime-library 'mml)
  (setq org-startup-folded t)
  (setq org-startup-indented t)
  (setq org-hide-leading-stars t)
  (setq org-blank-before-new-entry (quote ((heading)
                                           (plain-list-item . auto))))
  (setq org-list-allow-alphabetical t)
  (setq org-enforce-todo-dependencies t)
  (setq org-use-property-inheritance t)
  (setq org-cycle-separator-lines 0)
  (setq org-insert-heading-respect-content nil)
  (setq org-reverse-note-order nil)
  (setq org-show-following-heading t)
  (setq org-show-hierarchy-above t)
  (setq org-show-siblings (quote ((default))))
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t)
  (setq org-yank-adjusted-subtrees t)
  (setq org-id-method (quote uuidgen))
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-preserve-indentation t)
;;; Use the current window for C-c ' source editing
  (setq org-src-window-setup 'current-window)
  (setq org-confirm-babel-evaluate nil)
  (setq org-remove-highlights-with-change t)
  (setq org-deadline-warning-days 30)
  (setq org-table-export-default-format "orgtbl-to-csv")
  (setq org-link-frame-setup (quote ((vm . vm-visit-folder)
                                     (gnus . org-gnus-no-new-news)
                                     (file . find-file))))
  (setq org-log-done (quote time))
  (setq org-log-into-drawer t)
  ;; (setq org-log-into-drawer "LOGBOOK")
  (setq org-log-state-notes-insert-after-drawers nil)

  (setq org-export-with-timestamps nil)

  (setq org-return-follows-link t)
  (add-hook 'message-mode-hook
            (lambda ()
              (local-set-key "\C-c\M-o" 'org-mime-htmlize)))
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key "\C-c\M-o" 'org-mime-org-buffer-htmlize)))
  (setq org-structure-template-alist
        (quote (("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>")
                ("e" "#+begin_example\n?\n#+end_example" "<example>\n?\n</example>")
                ("q" "#+begin_quote\n?\n#+end_quote" "<quote>\n?\n</quote>")
                ("v" "#+begin_verse\n?\n#+end_verse" "<verse>\n?\n</verse>")
                ("c" "#+begin_center\n?\n#+end_center" "<center>\n?\n</center>")
                ("l" "#+begin_latex\n?\n#+end_latex" "<literal style=\"latex\">\n?\n</literal>")
                ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
                ("h" "#+begin_html\n?\n#+end_html" "<literal style=\"html\">\n?\n</literal>")
                ("H" "#+html: " "<literal style=\"html\">?</literal>")
                ("a" "#+begin_ascii\n?\n#+end_ascii")
                ("A" "#+ascii: ")
                ("i" "#+index: ?" "#+index: ?")
                ("I" "#+include %file ?" "<include file=%file markup=\"?\">"))))

  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "DELEGATED(g)" "|" "DONE(d!/!)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELED(c@/!)" "PHONE" "REFERENCE(r)"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "MediumSeaGreen" :weight bold)
                ("NEXT" :foreground "orange red" :weight bold)
                ("DONE" :foreground "MidnightBlue" :weight bold)
                ("WAITING" :foreground "magenta" :weight bold)
                ("DELEGATED" :foreground "magenta" :weight bold)
                ("SOMEDAY" :foreground "tan1" :weight bold)
                ("CANCELED" :foreground "tomato4" :weight bold))))

  (setq org-todo-state-tags-triggers
        (quote (("CANCELED" ("CANCELED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELED") ("HOLD")))))

  (setq org-use-fast-todo-selection t)

  (setq org-use-speed-commands t)
  (setq org-tag-persistent-alist '(("BK" . ?b)
                                   ("@Read" . ?r)
                                   ("Write" . ?w)
                                   ("FollowUp" . ?f)
                                   ("Home" . ?h)
                                   ("@Email" .?e)
                                   ))

  (setq org-agenda-files (quote (
                                 ~/Org"
                                 )))

  ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
  (setq org-capture-templates
        (quote (("t" "Todo" entry
                 (file+headline "~/Org/Tasks.org" "New")
                 "* TODO %?\n  %U\n"
                 :clock-in t :clock-resume t :empty-lines 1)
                ("a" "Appt" entry
                 (file+olp+datetree "~/Org/Appts.org")
                 "* %?\n %^T\n"
                 :time-prompt t)
                ("N" "Doing Now" entry
                 (file+headline "~/Org/Tasks.org" "New")
                 "* NEXT %?" :clock-in t)
                ("e" "Email actions")
                ("et" "Email Todo" entry
                 (file+headline "~/Org/Tasks.org" "New")
                 "* TODO %?\n  %i\n %U\n  %a\n"
                 :clock-in t :clock-resume t :empty-lines 1)
                ("ea" "Appt" entry
                 (file+olp+datetree "~/Org/Appts.org")
                 ;; "** APPT %? %^T\n %i\n %a\n")
                 "* %?\n %^T\n %i\n %a\n"
                 :time-prompt t)
                ("r" "Respond")
                ("rc" "critical" entry
                 (file+headline "~/Org/Tasks.org" "Critical Email")
                 "* TODO [#A] Respond to %:from on %:subject\n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("ri" "Important" entry
                 (file+headline "~/Org/Tasks.org" "Important Email")
                 "* TODO [#B] Respond to %:from on %:subject\n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("rn" "Normal" entry
                 (file+headline "~/Org/Tasks.org" "Normal Email")
                 "* TODO [#C] Respond to %:from on %:subject\n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("rs" "Social" entry
                 (file+headline "~/Org/Tasks.org" "Social Email")
                 "* TODO [#C] Respond to %:from on %:subject\n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("m" "Meeting")
                ("mo" "Other Meeting" entry
                 (file+olp+datetree "~/Org/OtherMeetings.org")
                 "* %? %U :OTHER:MTG:\n"
                 :empty-lines 1 :clock-in t :clock-resume t :tree-type week :unnarrowed t)
                ("n" "Note" entry
                 (file+headline "~/Org/Notes.org" "New")
                 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("o" "One-on-one")
                ("ob" "Bob" entry
                 (file+olp+datetree "~/Manager/One-on-One/bob.org")
                 "* %? %U :Bob:\n"
                 :empty-lines 1 :clock-in t :clock-resume t :tree-type week :unnarrowed t)
                ("p" "Proj")
                ("ph" "Hard Project" entry
                 (file+olp+datetree "~/ProjNotes/hardProj.org")
                 "* %? %U :HP:\n"
                 :empty-lines 1 :clock-in t :clock-resume t :tree-type week :unnarrowed t)
                ("l" "Research Log" entry
                 (file+olp+datetree "~/Org/ResearchLog.org")
                 "* %? :LOG:\n%U\n%i\n" :clock-in t :clock-resume t :tree-type week)
                ("R" "Read and Review")
                ("RC" "Critical" entry
                 (file+headline "~/Org/Tasks.org" "CRITICAL READ")
                 "* TODO [#A] Read about %:subject  %:from \n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("RI" "Important" entry
                 (file+headline "~/Org/Tasks.org" "IMPORTANT READ")
                 "* TODO [#B] Read about %:subject  %:from \n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("RN" "Normal" entry
                 (file+headline "~/Org/Tasks.org" "NORMAL READ")
                 "* TODO [#C] Read about %:subject  %:from \n%U\n%a\n"
                 :clock-in t :clock-resume t :immediate-finish t)
                ("i" "Interview")
                ("ip" "Phone Screen Notes" entry
                 (file+olp+datetree "~/Org/Interviews.org")
                 "* %? %U :PHONE:INTERVIEW:\n"
                 :empty-lines 1 :clock-in t :clock-resume t :tree-type week :unnarrowed t)
                ("io" "On Site Notes" entry
                 (file+olp+datetree "~/Org/Interviews.org")
                 "* %? %U :OS:INTERVIEW:\n"
                 :empty-lines 1 :clock-in t :clock-resume t :tree-type week :unnarrowed t)
                ("j" "Journal" entry (file+olp+datetree "~/Org/journal.org")
                 "* %U :crypt:\n %?\n %i\n"
                 :clock-in t :clock-resume t :empty-lines 1 :tree-type week :unnarrowed t)
                )))
  ;; Start the weekly agenda on Monday
  (setq org-agenda-start-on-weekday 1)

;;; Custom agenda command definitions
  ;; Writing these custom agenda commands has been a real pain. The
  ;; primary references that helped are the Org Manual sections 10.3.3,
  ;; 10.6.3, and Appendix A.7

  (setq org-agenda-custom-commands
        (quote (("N" "Notes" tags "NOTE"
                 ((org-agenda-overriding-header "Notes")
                  (org-tags-match-list-sublevels t)))
                (" " "Agenda"
                 ((agenda)
                  (tags-todo "PRIORITY=\"A\""
                             ((org-agenda-overriding-header "High Priority Tasks")
                              (org-tags-match-list-sublevels t)
                              (org-agenda-sorting-strategy
                               '(effort-up category-keep))))
                  (tags "+NEW+LEVEL>1"
                        ((org-agenda-overriding-header "New Notes and Tasks (Refile)")
                         (org-agenda-sorting-strategy
                          '(time-down priority-down todo-state-down))))
                  (tags-todo "+@Email+CRITICAL"
                             ((org-agenda-overriding-header "Email to Reply to ASAP")
                              (org-agenda-sorting-strategy
                               '(time-down priority-down todo-state-down))))
                  (tags-todo "+@Read+CRITICAL"
                             ((org-agenda-overriding-header "Things to Read ASAP")
                              (org-agenda-sorting-strategy
                               '(time-down priority-down todo-state-down))))
                  (tags-todo "PROJECT=\"Managing\"-PRIORITY=\"A\"-PRIORITY=\"C\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "Managing")
                              (org-agenda-sorting-strategy
                               '(todo-state-down priority-down category-down time-down effort-up))))
                  (tags-todo "PROJECT=\"Country\"-PRIORITY=\"A\"-PRIORITY=\"C\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "Countries")
                              (org-agenda-sorting-strategy
                               '(todo-state-down priority-down category-keep time-down effort-up))))
                  (tags-todo "PROJECT=\"PM\"-PRIORITY=\"A\"-PRIORITY=\"C\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "PM Requests")
                              (org-agenda-sorting-strategy
                               '(todo-state-down priority-down category-keep time-down effort-up))))
                  (tags-todo "PROJECT=\"No\"-PRIORITY=\"A\"-PRIORITY=\"C\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "Other, Non-@Project Tasks")
                              (org-agenda-sorting-strategy
                               '(todo-state-down priority-down category-keep time-down effort-up))))
                  (tags-todo "+PROJECT=\"Active\"-PRIORITY=\"A\"-PRIORITY=\"C\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "Active-@Project Tasks")
                              (org-agenda-sorting-strategy
                               '(category-keep priority-down todo-state-down time-down effort-up))))
                  (tags-todo "+PROJECT=\"Dormant\"+TODO=\"TODO\"|TODO=\"NEXT\""
                             ((org-agenda-overriding-header "Dormant-@Project Tasks")
                              (org-agenda-sorting-strategy
                               '(category-keep priority-down todo-state-down time-up effort-up))))
                  (tags-todo "+@Email+IMPORTANT+PROJECT=\"No\""
                             ((org-agenda-overriding-header "Important Email")
                              (org-agenda-sorting-strategy
                               '(time-down priority-down todo-state-down))))
                  (tags-todo "+@Read+IMPORTANT+PROJECT=\"No\""
                             ((org-agenda-overriding-header "Important Things to Read")
                              (org-agenda-sorting-strategy
                               '(time-down priority-down todo-state-down))))))
                ("g" "GeekTool Agenda" agenda ""
                 ((org-agenda-ndays 5)
                  (org-agenda-repeating-timestamp-show-all t)
                  (org-agenda-todo-keyword-format "%-7s")
                  (org-agenda-prefix-format "  %-10T%?-16t% s")
                  (org-agenda-show-inherited-tags nil)
                  (org-agenda-remove-tags 'prefix)
                  (org-agenda-tags-column 70))
                 ("~/Org/.org-agenda.old.txt"))
                ("G" "2nd GeekTool Agenda" tags-todo "PRIORITY=\"A\""
                 ((org-agenda-overriding-header "High Priority")
                  (org-agenda-sorting-strategy
                   '(time-down priority-down todo-state-up))
                  (org-agenda-todo-keyword-format "%-7s")
                  (org-agenda-prefix-format " %-10T%?-16t%? s")
                  (org-agenda-show-inherited-tags nil)
                  (org-agenda-remove-tags 'prefix)
                  (org-agenda-tags-column 70))
                 ("~/Org/.org-agenda.txt"))
                )
               )
        )

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)
  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)
  ;; Limit restriction lock highlighting to the headline only
  (setq org-agenda-restriction-lock-highlight-subtree nil)

  ;; Always hilight the current agenda line
  (add-hook 'org-agenda-mode-hook
            '(lambda () (hl-line-mode 1))
            'append)
  ;; Set agenda span to 5 days
  (setq org-agenda-span 5)

  (setq org-agenda-sticky t)

  ;; Keep tasks with dates on the global todo lists
  (setq org-agenda-todo-ignore-with-date nil)

  ;; Keep tasks with deadlines on the global todo lists
  (setq org-agenda-todo-ignore-deadlines nil)

  ;; Keep tasks with scheduled dates on the global todo lists
  (setq org-agenda-todo-ignore-scheduled nil)

  ;; Keep tasks with timestamps on the global todo lists
  (setq org-agenda-todo-ignore-timestamp nil)

  ;; Remove completed deadline tasks from the agenda view
  (setq org-agenda-skip-deadline-if-done t)

  ;; Remove completed scheduled tasks from the agenda view
  (setq org-agenda-skip-scheduled-if-done t)

  ;; Remove completed items from search results
  (setq org-agenda-skip-timestamp-if-done t)

  (setq org-agenda-include-diary nil)
  (setq org-agenda-diary-file "~/Org/diary.org")

  (setq org-agenda-insert-diary-extract-time t)

  ;; Include agenda archive files when searching for things
  (setq org-agenda-text-search-extra-files (quote (agenda-archives)))

  ;; Show all future entries for repeating tasks
  (setq org-agenda-repeating-timestamp-show-all t)

  ;; Show all agenda dates - even if they are empty
  (setq org-agenda-show-all-dates t)

  ;; Sorting order for tasks on the agenda
  (setq org-agenda-sorting-strategy
        (quote ((agenda habit-down time-up user-defined-up priority-down effort-up category-keep)
                (todo category-up priority-down effort-up)
                (tags category-up priority-down effort-up)
                (search category-up))))

                                        ; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

                                        ; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

                                        ; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

                                        ; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))


  (setq org-modules (quote (org-bbdb
                            org-bibtex
                            org-crypt
                            org-gnus
                            org-id
                            org-info
                            org-inlinetask
                            org-irc
                            org-rmail
                            org-w3m)))

  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume t)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)
  ;; Agenda clock report parameters
  (setq org-agenda-clockreport-parameter-plist
        (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
                                        ; Set default column view headings: Task Effort Clock_Summary
  (setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
                                        ; global Effort estimate values
                                        ; global STYLE property values for completion
  (setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 1:30 2:00 3:00 4:00 6:00")
                                      ("STYLE_ALL" . "habit"))))
  ;; Agenda log mode items to display (closed and state changes by default)
  (setq org-agenda-log-mode-items (quote (closed state)))
                                        ; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key (quote expert))
                                        ; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)
  (setq org-archive-mark-done nil)
  (setq org-archive-location "%s_archive::* Archived Tasks")
  (setq org-tags-exclude-from-inheritance (quote ("crypt")))
  (setq org-crypt-key "mysterycryptkey")
  (org-crypt-use-before-save-magic)
  (setq org-inlinetask-default-state `"TODO")
  (setq org-latex-default-packages-alist
        '(("" "inputenc")
          ("" "ulem")
          ("" "amsmath")
          ("" "amssymb")
          ("" "graphicx" t)
          ("" "longtable" nil)
          ("" "float" )
          ("" "url")
          ("" "rotating")
          ("" "verbatim")
          ("" "booktabs")
          ("" "tabularx")))

  (setq org-latex-packages-alist
        '(("" "org-preamble-xelatex" t)))
  (add-hook 'org-mode-hook 'turn-on-auto-fill 'append)
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  (add-hook 'org-mode-hook (lambda()
                             (define-key
                               evil-normal-state-local-map
                               (kbd "M-RET")
                               'org-meta-return)))
  )
;; To export to pandoc, edited org-pandoc-menu-entry directly in ox-pandoc.el
