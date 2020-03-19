;; SICP Exercise: 1.35-1.40
;; Dependencies: txt-1-3.scm

(define (cout-frac-iter n d k)
    (define (inner i result)
        (cond ((< i 1) result)
              (else (inner (- i 1) (/ (n i) (+ result (d i)))))))
    (inner k 0))

(define (cout-frac-rec n d k)
    (define (inner i)
        (cond ((> i k) 0)
              (else (/ (n i) (+ (d i) (inner (+ i 1)))))))
    (inner 1))

(define (gen-tan iter);; -> (tan x)
    (lambda (x) (cout-frac-iter (lambda (i) (if (= i 1) x (- (* x x)))) (lambda (i) (- (* i 2) 1)) iter)))