;; SICP Practice: 2
;; Metalinguistic Abstraction

(define (flat tree)
    (if (list? tree) 
        (map (lambda (x) (flat (car x)))
             tree))
        tree)

(define (odd-square x)
    (apply list
           (map (lambda (x) (* x x))
                (filter odd?
                        x))))

(define (inv x)
    (define (inner-loop res rem)
        (cond ((null? rem) res)
              (else (inner-loop (cons (car rem) res) (cdr rem)))))
    (inner-loop '() x))

(define (deep-inv x)
    (apply (lambda argl (inv argl))
           (map (lambda (x) (cond ((list? x) (deep-inv x))
                                  ((pair? x) (cons (cdr x) (car x)))
                                  (else x)))
                x)))

(define (my-accumulate func init seq)
    (define formalize
        (lambda (func init)
            (define target
                (lambda argl
                    (cond ((null? argl) init)
                    (else (func (car argl) (apply target (cdr argl)))))))
            target))
    (apply (formalize func init)
      seq))

;(define (my-map func seq)
;    (my-accumulate (lambda (x y) (cons (func x) y))
;        '()
;        seq))

(define (my-map func seq)
    (define inner
        (lambda (argl)
            (cond ((null? argl) '())
                  (else ((cons (func (car argl)) (inner (cdr argl))))))))
    (inner seq))

(define (my-map2 func . arglist)
    (define mk-car
        (lambda (argl)
            (cond ((null?  argl) '())
                  (else (cons (caar argl) (mk-car (cdr argl)))))))
    (define mk-cdr
        (lambda (argl)
            (cond ((null? (cdr argl)) '())
                  (else (cons (cdar argl) (mk-cdr (cdr argl)))))))

    (define mk-res
        (lambda (argl)
            (cond ((null?  argl) '())
                  (else (cons (func (mk-car argl)) (mk-res (mk-cdr argl)))))))
    (mk-res arglist))