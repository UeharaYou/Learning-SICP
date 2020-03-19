;; SICP Text: 1.2

(define (count-change amount)
    (define (cc amount kind-of-coin)
        (cond ((= amount 0) 1)
            ((or (< amount 0) (= kind-of-coin 0)) 0)
            (else (+ (cc amount
                         (- kind-of-coin 1))
                     (cc (- amount 
                            (first-denom kind-of-coin))
                         kind-of-coin)))))
    (define (first-denom kind)
        (cond ((= kind 1) 1)
              ((= kind 2) 5)
              ((= kind 3) 10)
              ((= kind 4) 25)
              ((= kind 5) 50)))
    (cc amount 5))

