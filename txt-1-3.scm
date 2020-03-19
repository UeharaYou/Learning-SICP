;; SICP Text: 1.3

(define (gen-newton-method func-deriv func-fixed-point);; -> (newton-method <func-g> <init-guess>)
    (lambda (func-g init-guess)
        (define (newton-trans func-g)
          (lambda (x) (- x
                         (/ (func-g x)
                            ((func-deriv func-g) x)))))
        (func-fixed-point (newton-trans func-g) init-guess)))

(define (gen-deriv dx);; -> (deriv <func-g>)
    (lambda (g)
        (lambda (x) 
          (/ (- (g (+ x dx)) (g x)) dx))))

(define (gen-fixed-point func-good-enough);; -> (fixed-point <func-f> <init-guess>)
    (lambda (f init-guess)
    	(define (attempt guess)
          (let ((next (f guess)))
        	(if (func-good-enough guess next)
                next
                (attempt next))))
        (attempt init-guess)))

(define (average-damp f x)
    (/ (+ x (f x)) 2))

;; Usage Example:
;;((gen-newton-method (gen-deriv 0.00001) (gen-fixed-point (lambda (guess next) (< (abs (- guess next)) 0.00001)))) (lambda (x) (- (* x x) 2)) 1.0)

