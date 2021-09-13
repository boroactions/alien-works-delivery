#!/usr/bin/env lisps

(bind-arguments
  (bundle-def-system (error "bundle-def-system required"))
  (bundle-name (error "bundle-name required"))
  (bundle-type (error "bundle-type required"))
  &key cache)


(defparameter *tmp-dir* (dir (or (uiop:getenv "RUNNER_TEMP")
                                 (uiop:getenv "TMPDIR")
                                 "/tmp/")))
(defparameter *cache-dir* (dir (or cache *tmp-dir*)))
(defparameter *bundler* (dir *tmp-dir* "delivery-bundle.lisp"))


(setf (uiop:getenv "QUICKLISP_HOME") (namestring (dir *cache-dir* "quicklisp")))
(let ((ql-setup (read-from-string ($ "ensure-quicklisp"))))
  ($ "install-quickdist" "http://dist.borodu.st/alien-works.txt")
  (load ql-setup))


(push (dir (uiop:getenv "GITHUB_WORKSPACE")) ql:*local-project-directories*)
(ql:register-local-projects)


(ql:quickload `(,bundle-def-system ,(keywordify (string+ :alien-works-delivery/ bundle-type))))
(alien-works-delivery:assemble-delivery-bundle bundle-name (keywordify bundle-type) *bundler*)

($ "$LISP" "--eval" (format nil "(load \"~A\" :external-format :ascii)" (namestring *bundler*)))
