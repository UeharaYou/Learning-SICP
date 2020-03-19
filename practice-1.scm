;; SICP Practice: 1

(define self-cons 
    (lambda (x y)
        (lambda (z) (z x y))))

(define self-cdr
    (lambda (z)
        (z (lambda (p q) q))))

(self-cdr (self-cons 1 2))

;; Step of eval/apply:

;; => e0 <TOP> : cons car apply eval bind

;; (eval '(cdr (cons 1 2) e0))

;; (apply (eval 'cdr e0)
;;        (ev-list '((cons 1 2)) e0))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list (eval '(cons 1 2) e0)))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list (apply (eval 'cons e0)
;;                     (ev-list '((1 2)) e0))))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list (apply (eval 'cons e0)
;;                     '(1 2))))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list (apply '(closure ((x y) (lambda (z) (z x y))) e0)
;;                     '(1 2))))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list (eval '(lambda (z) (z x y)) (bind '((x 1) (y 2)) e0))))

;; => e1 <e0> : x = 1; y = 2

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        (list '(closure ((z) (z x y)) e1)))

;; (apply '(closure ((z) (z (lambda (p q) q))) e0)
;;        '((closure ((z) (z x y)) e1)))

;; (eval '(z (lambda (p q) q)) (bind '((z (closure ((z) (z x y)) e1))) e0))

;; => e2 <e0> : z = (closure ((z) (z x y)) e1)

;; (apply (eval 'z e2)
;;        (ev-list '((lambda (p q) q)) e2))

;; (apply '(closure ((z) (z x y)) e1)
;;        (eval '(lambda (p q) q) e2))

;; (apply '(closure ((z) (z x y)) e1)
;;        '(closure ((p q) q) e2))

;; (eval '(z x y) (bind '((z (closure ((p q) q) e2))) e1))

;; => e3 <e1> : z = (closure ((p q) q) e2)

;; (apply (eval 'z e3)
;;        (ev-list '(x y) e3))

;; (apply '(closure ((p q) q) e2)
;;        '(1 2))

;; (eval 'q (bind '((p 1) (q 2)) e2))

;; => e4 <e2> : p = 1; q = 2

;; 2


