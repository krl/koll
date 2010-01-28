;; Author : Kristoffer Ström
;; License: public domain

;; very simple program to create a logfile of files worked on
;; can be used to keep track of work related projects for billing

;; just put this in elisp path and (require 'koll) in your config to have a go.

;; alist containing latest file writeout
(setf *koll-latest* nil
      ;; koll interval is the number of seconds that should pass between 
      ;; log entries of the same file. default 10 minutes.
      *koll-interval* (* 60 10)
      *koll-logfile* "~/.koll")

(defun koll-hook ()  
  (let* ((file (buffer-file-name))
	 (time (string-to-number (format-time-string "%s")))
	 (latest (aget *koll-latest* file)))
    (when (and file (or (not latest) (> (- time latest) *koll-interval*)))
      ;; write logfile
      (shell-command (concat "echo " (format-time-string "[%Y-%m-%d %H:%M] ") file " >> " *koll-logfile*))
      (aput '*koll-latest* file time)
      ;; "If one of them returns non-nil, the file is considered already written
      ;; and the rest are not called."
      nil)))

(add-hook 'write-file-hooks 'koll-hook)

(provide 'koll)