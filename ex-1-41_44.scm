;; SICP Exercise: 1.41-1.45

;; compose
;; parameters: f<function> g<function>
;; constraint: (eq (val-domain f) (def-domain g))
(define (compose func-f func-g)
    (lambda (x) (func-f (func-g x))))

;; double
;; parameters: f<function> 
;; constraint: (eq (val-domain f) (def-domain f))
(define (double func) (compose func func))

;; repeated
;; parameters: f<function> iter<int>
;; constraint: (and (eq (val-domain f) (def-domain f)) (>= iter 0))
(define (repeated func iter-ter)
      (define (inner-loop accum iter)
        (cond
          ((>= iter iter-ter) accum)
          (else (inner-loop (compose func accum)
                  (+ iter 1)))))
      (cond ((<= iter-ter 0) (lambda(x) x))
        (else (inner-loop func 1))))

;; nth-smooth
;; parameters: func<function> dx<rat> iter<int>
;; constraint: (and (eq (val-domain func) (def-domain func)) (>= iter 0))
(define (nth-smooth func dx iter)
    (define (gen-smooth dx);; yields a #smooth procedure 
      (lambda (func)
          (lambda (x) (/ (+ (func x)
                            (func (+ x dx))
                            (func (- x dx)))
                          3))))
    ((repeated (gen-smooth dx) iter) func))

