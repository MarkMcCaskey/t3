#|
 | Board is class with 2 variables a two dimensional list containing
 | symbols of the move type and a variable called state containing symbols
 | from the board-state type
 |
 | Super-board is a class with 2 variables, a 2 dimensonal list containing
 | instances of the board class and a winner variable of type board-state
 | which indicates the overall winner of the game
|#


(deftype board-state () '(xwin owin playable unplayble))
(deftype move () '(x o empty))
(deftype player () '(xer oer))

(defclass super-board ()
  ((super-board :accessor get-board
		:initform '(((make-instance board)
			     (make-instance board)
			     (make-instance board))
			    ((make-instance board)
			     (make-instance board)
			     (make-instance board))
			    (make-instance board)
			    (make-instance board)
			    (make-instance board)))
   (winner :accessor get-winner
	   :initform nil)))

(defclass board ()
  ((board :accessor get-board
	  :initform '((empty empty empty)
		      (empty empty empty)
		      (empty empty empty)))
   (state :accessor get-state
	   :initform nil)))

(defun first-valid (list)
  "Returns the first non-nil element in the list"
  (cl:some #'(lambda (y) (if (not (null y)) y)) list))

(defmethod super-set ((sb super-board) xpos ypos player)
  (let ((newx (mod xpos 3)) ;resolve indexing later
	(newy (mod ypos 3)))
    (setf (nth newx (nth newy (get-board sb)))
	  (cond ((eq player 'xer) 'x)
		((eq player 'oer) 'o)
		(t 'empty)))))

(defmethod super-load ((sb super-board) move-list)
  (let ((x-pos 0)
	(y-pos 0))
    (loop for m in move-list
       do (progn
	    (super-set super-board x-pos y-pos m)
	    (if (= (mod x-pos 8) 0)
	       (progn (setf x-pos 0)
		      (incf y-pos))
	       (incf x-pos))))))


(defun horizontal-win? (row)
  (if (and
       (not (eq (car row) 'empty))
       (eq (nth 0 row) (nth 1 row))
       (eq (nth 1 row) (nth 2 row))) (car row)))

(defun check-hw (rows)
  (first-valid
   (mapcar #'(lambda (y) (if (not (null y)) y))
	   (mapcar #'horizontal-win? rows))))

(defun check-diagonal-win (rows)
  "'((a _ b) (_ c _) (d _ e))"
  (destructuring-bind
	((a _1 b) (_2 c _3) (d _4 e))
      rows
    (declare (ignore _1 _2 _3 _4))
    (first-valid (list
		  (and (eq a c) (eq c e))
		  (and (eq b c) (eq c d))))))

(defmethod winner ((b board))
  (first-valid
   (append
    (check-hw (get-board b))
    (check-hw (apply
	       #'(lambda (a b c)
		   (mapcar #'list a b c))
	       (get-board b)))
    (check-diagonal-win (get-board b)))))

(defmethod set-winner ((b board) winner)
  (setf (get-state board) winner))

(defmethod set-winners ((sb super-board) winner-list)
  (loop for w in winner-list for bl in
       (mapcan #'(lambda (x) x) (get-board sb))
     do (set-winner b w)))
