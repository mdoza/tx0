;;; tx0.el --- Generate short urls with SDF's Tx0 service.

;; Copyright (C) 2020, All rights reserved.

;; Author: Matt D <mdoza@me.com>
;; Version: 0.1
;; Keywords: url, web
;; URL: http://github.com/mdoza/tx0

(require 'url)
(require 'dom)

(defun tx0 (s)
  "Create a short url with tx0.org."
  (interactive "sURL: ")
  (let* ((this-buffer (current-buffer))
         (escaped-url (url-hexify-string s))
         (url-request-method "POST")
         (url-request-data (concat "?=" escaped-url))
         (url-request-extra-headers
          '(("Content-Type" . "application/x-www-form-urlencoded"))))
    (with-temp-buffer
      (url-insert-file-contents "https://tx0.org")
      (let* ((dom (libxml-parse-html-region (point-min) (point-max)))
             (shorturl (nth 10 (dom-strings dom))))
        (switch-to-buffer this-buffer)
        (kill-new shorturl)
        (insert shorturl)))))
