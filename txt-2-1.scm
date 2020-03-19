;; SICP Text: 2.1

(define (make-type symbol)
    (lambda () (raise "illegal eval on type")))

(define (attach-type type data)
    (cons type data))

(define (type comb)
    (car comb))

(define (data comb)
    (cdr comb))

;; Abstraction: pairs || make-rat numer denom

(define (make-rat numer denom)
    (cond ((= denom 0) (raise "illegal denomiator"))
          (else (let ((g (gcd numer denom))) (attach-type 'RAT (cons (/ numer g) (/ denom g)))))))

(define (numer rat)
    (cond ((eq? (type rat) 'RAT) (car (data rat)))
          (else (raise "illegal type"))))

(define (denom rat)
    (cond ((eq? (type rat) 'RAT) (cdr (data rat)))
          (else (raise "illegal type"))))

;; Abstraction: numer denom || arith to rat

(define (mul-rat a b)
    (make-rat (* (numer a) (numer b))
              (* (denom a) (denom b))))

(define (div-rat a b)
    (make-rat (* (numer a) (denom b))
              (* (denom a) (numer b))))

(define (add-rat a b)
    (make-rat (+ (* (numer a) (denom b))
                 (* (denom a) (numer b)))
              (* (denom a) (denom b))))

(define (sub-rat a b)
    (make-rat (- (* (numer a) (denom b))
                 (* (denom a) (numer b)))
              (* (denom a) (denom b))))

(define (neg-rat a)
    (make-rat (- (numer a))
              (denom a)))

(define (invert-rat a)
    (make-rat (denom a)
              (numer a)))

(define (equal-rat? a b)
    (equal (* (numer a) (denom b))
           (* (numer b) (denom a))))


