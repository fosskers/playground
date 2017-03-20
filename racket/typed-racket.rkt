#lang typed/racket

; Export all definitions.
;(provide (all-defined-out))

; --- Type signatures --- ;
(: foo Integer)
(define foo 5)

(: inc (-> Integer Integer))
(define (inc n)
  (+ 1 n))

(: bar Integer)
(define bar 8)

(: biff Integer)
(define biff 10)

(define boff 17)

; --- Union types --- ;
(define-type Tree (U leaf node))
(struct leaf ([val : Number]))
(struct node ([left : Tree] [right : Tree]))

; --- Polymorphism --- ;
(define-type (Maybe a) (U Nothing (Just a)))
(struct Nothing ())
(struct (a) Just ([val : a]))

; We need `All` here or else the type checker complains that `a` is unbound.
(: list-len (All (a) (-> (Listof a) Integer)))
(define (list-len l)
  (if (null? l)
      0
      (add1 (list-len (cdr l)))))

(: identity (All (a) (-> a a)))
(define (identity a) a)
