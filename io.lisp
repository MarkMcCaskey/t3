;;;; file for communicating with the AI games server
;;;; All communication is on STDIN and STDOUT

#|
 | Protocols:
 |
 | input:
 | settings timebank t
 | settings time_per_move t
 | settings player_names [b,...]
 | settings your_bot b
 | settings your_botid i
 | update game round i
 | update game move i
 | update game field [c,...]
 | update game macroboard [s,...]
 | action move t
 |
 | output:
 | place_move i i
 |#

(defun dispatch-signal (signal board game-state)
  "signal is a list of strings"
  (case (car signal)
    ("update"   (update-dispatch   (cdr signal) board game-state))
    ("action"   (action-dispatch   (cdr signal) board game-state))
    ("settings" (settings-dispatch (cdr signal) game-state))
    (t          (format t "error handle here later"))))

(defun settings-dispatch (signal game-state)
  (case (car signal)
    ("timebank"      (setf (get-time-bank     game-state) (cadr signal)))
    ("time_per_move" (setf (get-time-per-move game-state) (cadr signal)))
    ("player_names"  (setf (get-player-names  game-state) (cdr  signal)))
    ("your_bot"      (setf (get-bot-name      game-state) (cadr signal)))
    ("your_bot_id"   (setf (get-bot-id        game-state) (cadr signal)))
    (t (format t "error handle here later"))))

(defun action-dispatch (signal board game-state)
  (case (car signal)
    ("move" )
    (t (format t "error handle here later"))))

(defun update-dispatch (signal board)
  (if (not (equal (car signal) "game"))
      (format t "error handle here later")
      (case (cdar signal)
	("round")
	("move")
	;; field is a list of numbers 0 is empty, 1 is x and 0 is o
	("field" (super-load board (parse-board-layout (cddar signal))))
	("macroboard" ())
	(t (format t "error handle here later")))))

(defun parse-board-layout (board-layout)
  (mapcar
   #'(lambda (x)
       (case x
	 (0 'empty)
	 (1 'x)
	 (2 'o)
	 (t (format t "handle invalid board from server later"))))))

(defun output-best-move (board)
  (declare (ignore board))
  (format t "place_move -1 -1"))
