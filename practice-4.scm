;; SICP Practice: 4

;; (protocol <dict> '(<entry> ...))
;; (protocol <closure> '('closure <list> <exp> <env>))
;; (protocol <env> '(<dict> . <env>))

(define make-dict
    (lambda (k v)
        (define make-entries 
            (lambda (key-l val-l old-dict)
                (cond ((and (null? key-l) (null? val-l)) '())
                      ((and (not (null? key-l)) (null? val-l)) (raise 'too-few-vals))
                      ((and (null? key-l) (not (null? val-l))) (raise 'too-few-keys))
                      (else (cond ((pair? key-l) (cons (cons (car key-l) (car val-l)) (make-entries (cdr key-l) (cdr val-l))))
                                  (else (list (cons key-l val-l))))))))

        (define make-entries-2
            (lambda (key-p val-p)
                (define translate-pair
                    (lambda (key-r val-r) 
                    	(cond ((atom? key-r) (cons (list key-r) (list val-r))) 
                              (else (let ((result (translate-pair (cdr key-r) (cdr val-r))))
                                         (cons (cons (car key-r) (car result))
                                               (cons (car val-r) (cdr result))))))))

                (cond ((and (list? key-p) (list? val-p)) 
                       (map (lambda (x y) (cons x y))
                            key-p
                            val-p))
                      ((and (pair? key-p) (pair? val-p)) (let ((trans (translate-pair key-p val-p))) (make-entries-2 (car trans) (cdr trans))))
                      (else (raise 'type-error)))))

	    (let ((content (make-entries-2 k v))) 
            
            (define merge '())

            (define lookup
                (lambda (key)
                     (map cdr
                          (filter (lambda (x) (eq? (car x) key))
                                  content))))
            (define update!
                (lambda (key new-val)
                    (set! content (map (lambda (x) (if (eq? (car x) key) (cons key new-val) x))
                                       content))))
            
            (define add! update!)
            (define dict-dispatch
                (lambda (message)
                    (cond ((eq? message 'lookup) lookup)
                          ((eq? message 'update!) update!) 
                          (else (raise-continuable 'unknown-message)))))
            dict-dispatch)))

(define make-env 
    (lambda (dict ref-super-env)
        (let ((content (cons dict ref-super-env)))
            (define env-dispatch
                (lambda (message)
                    (cond ((eq? message 'add!) (lambda (dict) (add-dict! dict (car content))))
                          ((eq? message 'update!) (lambda (dict) (update-dict! dict (car content))))
                          (else (raise-continuable 'unknown-message)))))
            env-dispatch)))


