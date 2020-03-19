;; Visual Ambiguity of set! forms from Closure 

;; Scheme
(define time-cnt 0)
(define (a) 1234)
(define prob (make-probe-func (lambda x (if (< time-cnt 10) (begin (set! time-cnt (+ time-cnt 1)) (display "pre")) (abort))) (lambda (a ret) (display "post"))))

(set! a (lambda arglist (apply prob (cons a arglist))))))

(a)

;; CommonLisp
(defparameter time-cnt 0)
(defparameter a (lambda () 1234))
(defun prob (tar)
(if (< time-cnt 10) (progn (setf time-cnt (+ time-cnt 1)) (format t "Q") (funcall tar)) 'fucked))
(funcall a)

(setf a (lambda () (prob a)))

(funcall a)

;; Lambda Expression (closure) surppressed the evaluation of symbols in its body till called as a procedure, a co-incidence of which is the visual ambiguity of set! form to recursive variables against to procedures.

;; Good way
(set! a (let ((c a)) (lambda arglist (apply prob (cons c arglist)))))))