;; SICP Exercise 2.4

(define (self-cons x y)
    (lambda (m) (m x y)))

(define (self-car z)
    (z (lambda (p q) p)))

(define (self-cdr z)
    (z (lambda (p q) q)))

(define-syntax self-cons-syn 
    (syntax-rules ()
        ((self-cons-syn x y)
        (lambda (z) (z (delay x) (delay y))))))

(define-syntax self-cdr-syn
    (syntax-rules ()
        ((self-cdr-syn z)
        (z (lambda (p q) (force q))))))

(define-syntax self-car-syn
    (syntax-rules ()
        ((self-car-syn z)
        (z (lambda (p q) (force p))))))
