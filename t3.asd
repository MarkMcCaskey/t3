;;;; t3.asd

(asdf:defsystem #:t3
  :description "Ultimate Tic Tac Toe bot for the ai games"
  :author "Mark McCaskey"
  :license "Modified BSD License"
  :serial t
  :depends-on ()
  :pathname "./"
  :components ((:file "package")
  			   (:file "t3")))

