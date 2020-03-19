;; SICP Practice: 5
;; Continuation Passing Style

(define identity (lambda (x) x))

(define (yin-yang)
    (let* ((yin ((lambda (foo) (display "@") foo) (call/cc (lambda (bar) bar))))
           (yang ((lambda (foo) (display "*") foo) (call/cc (lambda (bar) bar)))))
        (yin yang)))

(define my-flat-map
    (lambda (func arglist)
        (define inner-loop
            (lambda (continuation arglist)
                (cond ((null? arglist) (continuation '()))
                      ;; (else (cons (func (car a)) (my-flat-map func (cdr a)))))))
                      ;; Context: [cons<...>, cont]
                      (else (inner-loop (lambda (hole) (continuation (cons (func (car arglist)) hole))) (cdr arglist))))))
        (inner-loop identity arglist)))

(define my-map
    (lambda (func . arglist)
        (define inner-loop
            (lambda (continuation arglist)
                (display "iL: ") (display arglist) (newline)
                (cond ((null? (car arglist)) (continuation '()))
                      (else (inner-loop (lambda (hole) (continuation (cons (apply func (my-flat-map car arglist)) hole))) (my-flat-map cdr arglist))))))
        (inner-loop identity arglist)))

