#lang racket  ; required to make this a proper module.

; Export all definitions.
(provide (all-defined-out))

; Importing
(require racket/vector)

; Static values.
(define jack "jack")

; Functions
(define (cat? cat)
  (equal? cat "cat"))

; if.
(define (greet-by-age age)
  (if (equal? age 3)
      "You're three!"
      "You're a weird age."))

; cond.
(define (better-greet age)
  (cond [(>= 10 age) "You're a young one."]
        [(>= 19 age) "A teenager, eh."]
        [else "Let's get a beer."]))

; let. `let*` lets later bindings use earlier ones.
(define (guess g)
  (let ([ai (random 10)])
    (cond [(equal? ai g) "Dang, tied!"]
          [(> ai g) "The AI wins!"]
          [else "You win!"])))

; Lists and Vectors
(define l0 (list 1 2 3))
; (first l0)
; (rest l0)
(define l1 (vector-immutable 1 2 3))
; (vector-map + #(1 2) #(3 4))

; Benchmarking
; (time (println "Jack!"))

; Numbers
(define n0 1)    ; Exact integer
(define n1 1/2)  ; Exact ratio
(define n2 0.5)  ; Inexact float

; Characters and Strings
(define c0 #\A)
(define c1 "A String!")
(define c2 #"Bytes!")  ; A bytestring.

; Symbols and Keywords
(define k0 'some-symbol)
(define k1 '#:somekeyword)

; (Immutable) Hash Tables / Maps
(define h0 (hash 'jack 3 'qtip 8))
; (hash-ref h0 'qtip)

; Pattern Matching
(define (m0 n)
  (match n
    [1 "It's a one!"]
    [2 "It's a two!"]
    [_ "No idea."]))

(define (m1 n)
  (case n  ; `case` has O(logn) dispatch time, `match` doesn't. `match` is more expressive.
    [(1) "It's a one!"]
    [(2) "It's a two!"]
        [else "No idea."]))

; Structs. Immutable by default.
(struct point (x y)     ; Autogenerates accessor functions
        #:transparent)  ; Print normally
; (point-x (point 1 2))

; IO Streams (actual streaming)
(define io0 (open-output-file "data" #:exists 'truncate))
(display "hi there" io0)
(close-output-port io0)

;; (call-with-output-file "data" ; closes the file for you afterward.
;;   #:exists 'truncate
;;   (lambda (out)
;;     (display "hi again!" out)))
;; (call-with-input-file "data"
;;   (lambda (in)
;;     (read-line in)))

; (printf "My cat's name is ~a" "Jack")

; Count all lines in a large file, with no RAM overhead.
;; (define (count-em-all file)
;;   (call-with-input-file file
;;     (lambda (in)
;;       (sequence-fold (lambda (acc v)
;;                        (+ 1 acc))
;;                      0
;;                      (in-lines in)))))
