;;SICP Lecture: 6.001/6

(define self-eval
    (lambda (expr env)
        (cond ((literal? expr) expr)
              ((quotation? expr) (quotation-content expr))
              ((variable? expr) (lookup-val expr env))
              ((definition? expr) (if (env-contains? env (definition-symbol expr)) (raise 'eval-redef) (env-update! env (definition-symbol expr) (definition-val expr))))
              ((assignment? expr) (if (env-contains? env (definition-symbol expr)) (env-update! env (definition-symbol expr) (definition-val expr)) (raise 'eval-unbound)))
              ((lambda-exp? expr) (make-closure (lambda-parameter expr) (lambda-body expr) env))
              ((branch? expr) (self-eval-cond expr env))
              ((progn? expr) (self-eval-seq expr env))
              
              ((application? expr) (self-apply (self-eval (app-operator expr)
                                               (self-eval-list (app-parameter expr)))))

              (else (raise 'syntax-error)))))

(define self-apply
    (lambda (func args)
        (cond ((closure? func) (self-eval (closure-body func)
                                          (make-env (make-dict (closure-parameter func) args) (closure-env func))))
              (else (raise 'application-error)))))
