;; SICP Practice: 6
;; Stream

;; BASIC CONCEPT
;; Current Implementations of Scheme includes memo-proc by default
;; Streams are CONSTANTS

;(define-syntax delay
;    (syntax-rules ()
;      ((delay x) (lambda () x))))
;(define-syntax force
;    (syntax-rules ()
;      ((force x) (x))))

;; Inefficient Implementation: 
;; Redundant Computation caused by multiple entities created on Lambda Evaluation
;(define (sqrt-stream-less x)
;      (stream-cons 1.0
;        (stream-map (lambda (guess) 
;                      (/ (+ guess (/ x guess)) 2))
;          (sqrt-stream-less x)))) ; Create new Entities!



;; Auxiliaries

(define-syntax stream-cons
    (syntax-rules ()
      ((stream-cons a b)
       (cons a (delay b)))))
(define (stream-car x) (car x))
(define (stream-cdr x) (force (cdr x)))

(define stream-null? null?)
(define empty-stream '())

(define (func_or . arglist)
    (cond ((null? arglist) #f)
          ((not (car arglist)) (apply func_or (cdr arglist)))
          (else #t)))

(define (func_and . arglist)
    (cond ((null? arglist) #t)
          ((not (car arglist)) #f)
          (else (apply func_and (cdr arglist)))))

(define (stream-list . arglist)
    (if (null? arglist)
        empty-stream
        (stream-cons (car arglist)
          (apply stream-list (cdr arglist)))))

(define (stream-map func . tarlist)
    (define mapped-stream
        (if (apply func_or (map stream-null? tarlist))
            empty-stream
            (stream-cons (apply func (map stream-car tarlist))
              (apply stream-map (cons func (map (lambda (x) (stream-cdr x)) tarlist))))))
    mapped-stream)

(define (stream-filter func target . arglist)
    (define filtered-stream
        (if (or (stream-null? target) (apply func_or (map stream-null? arglist)))
            empty-stream
            (if (apply func (cons (stream-car target) (map stream-car arglist)))
                (stream-cons (stream-car target)
                   (apply stream-filter (cons func (cons (stream-cdr target) (map stream-cdr arglist)))))
                (apply stream-filter (cons func (cons (stream-cdr target) (map stream-cdr arglist)))))))
    filtered-stream)

(define (stream-merge s1 s2)
    (define merged-stream
        (cond 
          ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
              (cond 
                ((< s1car s2car)
                 (stream-cons s1car (stream-merge (stream-cdr s1) s2)))
                ((> s1car s2car)
                 (stream-cons s2car (stream-merge s1 (stream-cdr s2))))
                (else
                  (stream-cons s1car (stream-merge (stream-cdr s1) (stream-cdr s2)))))))))
    merged-stream)

(define (stream-scale stream factor)
    (stream-map (lambda (x) (* x factor)) stream))

(define (stream-truncate ter? stream)
    (define truncated-stream
        (let ((res (stream-car stream)))
          (if (ter? res)
              empty-stream
              (stream-cons res (stream-truncate ter? (stream-cdr stream))))))
    truncated-stream)

(define (stream-ref stream n)
    (if (stream-null? stream)
        'error
        (if (= n 0)
            (stream-car stream)
            (stream-ref (stream-cdr stream) (- n 1)))))

(define (stream-display stream count)
      (define (inner fs i)
        (cond ((or (stream-null? fs) (> i count)) 'done)
              (else (display (stream-car fs)) 
                    (newline) 
                    (inner (stream-cdr fs) (+ i 1)))))
      (inner stream 0))

;; Utilities

(define one-series (stream-cons 1 one-series))

(define integer-series (stream-cons 1 (stream-map + one-series integer-series)))

(define (integral-series x) (stream-map / x integers))

(define cosine-series (stream-cons 1 (stream-map - (integral-series sine-series))))

(define sine-series (stream-cons 0 (stream-map + (integral-series cosine-series))))

(define hamming-series (stream-cons 1 (stream-merge (stream-scale hamming-series 2) (stream-merge (stream-scale hamming-series 3) (stream-scale hamming-series 5)))))

(define (sqrt-approximation x) (define guesses (stream-cons 1.0 (stream-map (lambda (guess) (/ (+ guess (/ x guess)) 2)) guesses))) guesses)

(define sieve-series
            (stream-cons (stream-cdr integer-series) ; Int from 2
              (stream-map 
                (lambda (x-stream) 
                  (letrec* ((mod-x (stream-car x-stream)) (sq-mod-x (* mod-x mod-x)))
                    (set! cnt (+ cnt 1))
                    (stream-filter 
                      (lambda (x) 
                        (or (< x sq-mod-x)
                            (not (= (mod x mod-x) 0))))
                      (stream-cdr x-stream))))
                sieve-series)))

(define prime-series (stream-map stream-car sieve-series))
