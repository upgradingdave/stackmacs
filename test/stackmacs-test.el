
(ert-deftest stackmacs/json-test ()
  (let* ((json-res (with-current-buffer (find-file-noselect "test/questions.json")
                     (buffer-string)))
         (json-structure (json-read-from-string json-res))
         (questions (cdr (cadddr json-structure))))
    (should (vectorp questions))))


;; (let* ((json-res (with-current-buffer (find-file-noselect "test/questions.json")
;;                           (buffer-string)))
;;               (json-structure (json-read-from-string json-res))
;;               (questions (cdr (cadddr json-structure)))
;;               (q1 (elt questions 1)))
;;          (stackmacs/find-attr "title" q1))


