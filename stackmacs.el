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

;; A client for browsing stackoverflow and answering questions. 

;;; Code:

(require 'cookbook)

(defvar smacs/buffer "*stackmacs*" 
  "Buffer used to view results of searches, etc")

(defvar smacs/query-most-recent-questions 
  "http://api.stackexchange.com/2.1/questions?order=desc&sort=creation&site=stackoverflow&filter=withbody")

(defun smacs/find-attr (test seq)
  "Grab the element with key that matches test. Useful for picking values out of a question."
  (find test seq :test (lambda (x y) (string= x (car y)))))

(defun smacs/format-question (q)
  (format "* %s" (cdr (smacs/find-attr "title" q))))

(defun smacs/display-response (status)
  "Convert and display results from api call"
  (let* ((json-res (ckbk/url-retrieve-body-callback status))
         (json-structure (json-read-from-string json-res))
         (questions (cdr (cadddr json-structure)))
         (q1 (elt questions 1)))
    (switch-to-buffer (get-buffer-create smacs/buffer))
    (insert (smacs/format-question q1))))

(defun smacs/browse-questions ()
  (interactive)
  (let ((url smacs/query-most-recent-questions))
    (url-retrieve url #'smacs/display-response)))

;;; Major Mode stuff

(define-derived-mode stackmacs-mode text-mode "stackmacs") 

(global-set-key (kbd "C-c C-s bq") 'smacs/browse-questions)

(provide 'stackmacs)
