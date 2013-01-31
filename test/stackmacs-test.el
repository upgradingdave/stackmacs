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

(ert-deftest smacs/format-test ()
  (let* ((json-res (with-current-buffer (find-file-noselect "test/questions.json")
                     (buffer-string)))
         (json-structure (json-read-from-string json-res))
         (questions (cdr (cadddr json-structure))))

    (should (string= ":php:redirect:post:" (smacs/format-tags '["php" "redirect" "post"])))

    (should (string= "* [0v/0a] Dispatcher.Invoke does not catch exception :c#:windows-phone-8:\n\n[[http://stackoverflow.com/questions/14595969#new-answer][Click to Answer]]\n\n#+begin_src html html\n<p>I have a code below to get a response from HTTP GET:</p>\n\n<pre><code>private void ResponseReady(IAsyncResult aResult)\n        {\n            HttpWebRequest request = aResult.AsyncState as HttpWebRequest;\n\n            try\n            {\n                this.Dispatcher.BeginInvoke(delegate()\n                {\n                    HttpWebResponse response = (HttpWebResponse)request.EndGetResponse(aResult);\n</code></pre>\n\n<p>The problem when there is no connection, it will stop at the <code>response</code> row. It doesn't catch the exception. Is it because of the <code>Dispatcher.Invoke</code>?</p>\n\n<p>Thank you.</p>\n#+end_src\n" (smacs/format-question (elt questions 1))))))

