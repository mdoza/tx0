;;; tx0.el --- Short urls with tx0.org               -*- lexical-binding: t; -*-

;; Copyright (C) 2020  azod

;; Author: azod <azod@sdf.org>
;; Version: 1.0
;; Keywords: lisp, comm

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This program shortnes a URL by using the tx0.org url service.

;;; Code:

(require 'dom)

(defvar tx0-short-url nil
  "Where the short url is stored.")

(defun tx0 ()
  "Create a short url with tx0.org"
  (interactive)
  (let ((url (url-get-url-at-point)))
    (if (= (length url) 0)
	(tx0/with-minibuffer-input)
      (tx0/create-short-url url))))

(defun tx0-insert-short-url ()
  "Inserts the short url at where the cursor is located."
  (interactive)
  (insert tx0-short-url))

(defun tx0/with-minibuffer-input ()
  "Create a short url using user input."
  (let ((url (read-from-minibuffer "URL: ")))
    (tx0/create-short-url url)))

(defun tx0/create-short-url (url)
  "Connect to tx0.org and create the url."
  (let* ((escaped-url (url-hexify-string url))
	 (url-request-method "POST")
	 (url-request-data (concat "?=" escaped-url))
	 (url-request-extra-headers
	  '(("Content-Type" . "application/x-www-form-urlencoded"))))
    (with-temp-buffer
      (url-insert-file-contents "https://tx0.org")
      (let* ((dom (libxml-parse-html-region (point-min) (point-max)))
	     (shorturl (nth 10 (dom-strings dom))))
	(setq tx0-short-url shorturl)
	(message (concat "Short tx0 url created: " tx0-short-url))
	(kill-new shorturl)))))
  
(provide 'tx0)
;;; tx0.el ends here
