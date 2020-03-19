;; Analysis Tools
;; Platform: chez

(define make-probe-func
        (lambda (pre-proc pro-proc)
          (let ((probe-storage #f))
            (lambda (target . arglist)
              (begin 
                 (pre-proc probe-storage arglist)
                 (let ((ret (apply target arglist)))
                   (pro-proc probe-storage ret)
                   ret))))))

(define make-probe-repo
        (lambda ()
          (let ((repo (make-eq-hashtable)))
            (define register!
                    (lambda (key value)
                      (cond ((hashtable-contains? repo key)
                             (raise-continuable 'duplicated-registration))
                            (else (hashtable-set! repo key value)))))
            (define quest
                    (lambda (key)
                      (cond ((hashtable-contains? repo key)
                             (hashtable-ref repo key #f))
                            (else (raise-continuable 'unregisted-key)))))
            (define unregister!
                    (lambda (key)
                      (cond ((hashtable-contains? repo key)
                             (hashtable-delete! repo key))
                            (else (raise-continuable 'unregisted-key)))))

            (define dispatcher
                    (lambda (message . arglist)
                      (cond ((eq? message 'register!) (apply register! arglist))
                            ((eq? message 'quest) (apply quest arglist))
                            ((eq? message 'unregister!) (apply unregister! arglist))
                            (else (break #f)))))
            dispatcher)))
;;(raise-continuable 'unknown-message)
(define-syntax hook
        (syntax-rules (probe! unprobe!)
          ((_ 'probe! #;probe: symbol #;with: prob)
           (begin
             (set! symbol (let ((tar symbol)) (lambda arglist (apply prob (cons tar arglist)))))))
          ((_ 'probe! #;probe: symbol #;with: prob #;save-origion-to repo)
           (let ((repository repo)) 
             (repository 'register! 'symbol symbol) 
             (set! symbol (lambda arglist (apply prob (cons (repository 'quest 'symbol) arglist))))))
          ((_ 'unprobe! #;recover-origion: symbol #;from: repo)
           (begin
             (set! symbol (repo 'quest 'symbol))
             (repo 'unregister! 'symbol)))))

(define probe-func-time
        (lambda (target output-port)
          (let ((time (current-time)))
            (target)
            (let  ((interval (time-difference (current-time) time)))
              (format output-port "~s ~s\n" x (+ (* (time-second interval) 1000000000) (time-nanosecond interval)))))))
