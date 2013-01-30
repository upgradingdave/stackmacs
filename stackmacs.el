;;; stackmacs.el --- Stackoverflow client for emacs

;; Copyright 2013 Dave Paroulek, Preferred Version LLC

;; Authors: Dave Paroulek <upgradingdave@gmail.com>
;; Version: 0.0.1
;; Keywords: stackoverflow, client
;; URL: tbd

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; A client for browsing stackoverflow questions. 

;;; Code:

(require 'cl)
(require 'cookbook)

(defvar smacs/buffer "*stackmacs*" 
  "Buffer used to view results of searches, etc")

(setq smacs/query-most-recent-questions 
  "http://api.stackexchange.com/2.1/questions?order=desc&sort=creation&site=stackoverflow&filter=!)sX46RY9K1L2Vf.YNjW0")

(defvar smacs/filter
  "filter=!)sX46RY9K1L2Vf.YNjW0")

(defun smacs/find-attr (test seq)
  "Grab the element with key that matches test. Useful for picking values out of a question."
  (find test seq :test (lambda (x y) (string= x (car y)))))

(defun smacs/click ()
  (interactive)
  (let ((uri (get-text-property (point) 'uri)))
    (if uri
	(browse-url uri))))

(defun smacs/fontify-url (text url)
  "Note that I think `set-text-properties` get overridden by org magic,
so just insert org link"
  (concat "[[" url "][" text "]]"))

(defun smacs/format-question (q)
  (format (concat "* [%dv/%da]" 
                  " %s\n\n"
                  (smacs/fontify-url "Click to Answer" 
                                     "http://stackoverflow.com/questions/%d#new-answer") 
                  "\n\n#+begin_src html html\n%s#+end_src\n") 
          (cdr (smacs/find-attr "up_vote_count" q))
          (cdr (smacs/find-attr "answer_count" q))
          (cdr (smacs/find-attr "title" q))
          (cdr (smacs/find-attr "question_id" q))
          (cdr (smacs/find-attr "body" q))))

(defun smacs/buffer-reset ()
  (switch-to-buffer (get-buffer-create smacs/buffer))
  (stackmacs-mode)
  (visual-line-mode 1)
  (erase-buffer))

(defun smacs/display-response (status)
  "Convert and display results from api call"
  (let* ((json-res (ckbk/url-retrieve-body-callback status))
         (json-structure (json-read-from-string json-res))
         (questions (cdr (cadddr json-structure))))
    (smacs/buffer-reset)
    (save-excursion
      (loop for q across questions do
            (insert (smacs/format-question q)))
      (org-overview))
;;    (show-subtree)
    ))

(defun smacs/browse-questions ()
  (interactive)
  (let ((url smacs/query-most-recent-questions))
    (url-retrieve url #'smacs/display-response)))

;;; Major Mode stuff
(defun stackmacs ()
  (interactive)
  "Start stackmacs and load questions"
  (smacs/browse-questions))

(define-derived-mode stackmacs-mode org-mode "stackmacs" 
  "Major Mode for browsing StackOverflow Questions
\\{stackmacs-mode-map}")

(let ((sm stackmacs-mode-map))
  (define-key sm (kbd "r") 'smacs/browse-questions))

(global-set-key (kbd "C-c s q") 'smacs/browse-questions)

(provide 'stackmacs)
