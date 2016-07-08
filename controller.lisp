#|
 | Layer between IO/other signals and the rest of the program
 | high level access to do useful things
 |
|#

(defclass game-info ()
  ((time-bank     :accessor get-time-bank
	          :initform 0)
   (time-per-move :accessor get-time-per-move
		  :initform 0)
   (player-names  :accessor get-player-names
		  :initform '("player 1" "player 2"))
   (bot-name      :accessor get-bot-name
	          :initform "t3")
   (bot-id        :accessor get-bot-id
	          :initform 7615242)))


(defun best-move (board player)
  "Returns list containing 'best move'"
  )

;;temporarily for single board for testing purposes
(defun iterative-depth-search (board player depth)
  "brute force search"
  (let ((value-matrix '(0 0 0 0 0 0 0 0 0))
	(board-list (mapcan #'(lambda (x) x) (get-board board))))
    (loop for p in board-list for i in value-matrix
	 do (setf i ))))

(defun try-move (board-list player move)
  "recursively computes"
  )

;; starting move bit board 00 - empty, 01 - x ; 10 - o
;; if 1 move and masking with 0x4444 is >= 1 then center-side position
;; if 1 move and masking with 0x11011 is >= 1 then corner position
;; if 1 move and masking with 0x100 is >= 1 then middle position
;;
;;
