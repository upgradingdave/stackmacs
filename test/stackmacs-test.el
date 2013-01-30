(require 'stackmacs)

;; Convenience functions for playing around with api calls

(defun smacs/url-retrieve-test-callback (status)
  "Convenience for looking at response of api calls"
  (let* ((json-res (ckbk/url-retrieve-body-callback status)))
    (switch-to-buffer (get-buffer-create smacs/buffer))
    (erase-buffer)
    (insert json-res)))

(defun smacs/url-retrieve-test ()
  (let ((url smacs/query-most-recent-questions))
    (url-retrieve url #'smacs/url-retrieve-test-callback)))

;; Stackmacs Tests

(ert-deftest smacs/json-test ()
  (let* ((json-res (with-current-buffer (find-file-noselect "test/questions.json")
                     (buffer-string)))
         (json-structure (json-read-from-string json-res))
         (questions (cdr (cadddr json-structure))))
    (should (vectorp questions))))


;; (setq q1  (let* ((json-res (with-current-buffer (find-file-noselect "test/questions.json")
;;                              (buffer-string)))
;;                  (json-structure (json-read-from-string json-res))
;;                  (questions (cdr (cadddr json-structure)))
;;                  (q1 (elt questions 1)))
;;             q1))

