#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/json)
(require lang/posn)

(define url "http://bloomington.doublemap.com/map/v2/buses")
(define bloomington-map (bitmap "bloomington-map.png"))
(define sprite
  (beside (rectangle 10 6 "solid" "blue")
          (rectangle 4 6 "solid" "black")))
(struct world [xmin xmax ymin ymax])
(struct bus [lon lat dir])
(define bloomington-view
  (world -86.52846 -86.49543 39.163165 39.186316))
(define width 770)
(define height 697)

(define (convert a1 b1 a2 b2 a)
  (/ (+ (* b1 (- a2 a)) (* b2 (- a a1))) (- a2 a1)))


(define (cartesian->screen w lop)
  (map (lambda (p)
         (make-posn (convert (world-xmin w)
                             0
                             (world-xmax w)
                             width
                             (posn-x p))
                    (convert (world-ymin w)
                             height
                             (world-ymax w)
                             0
                             (posn-y p)))) lop))


(define (cartesian->screen->bus w lop)
  (map (lambda (p)
         (bus (convert (world-xmin w)
                             0
                             (world-xmax w)
                             width
                             (bus-lon p))
                    (convert (world-ymin w)
                             height
                             (world-ymax w)
                             0
                             (bus-lat p))
                    (bus-dir p))) lop))


(define (lookup s lom)
  (cond [(empty? lom) (error "Error")]
        [(string=? (member-name (first lom)) s)
         (member-value (first lom))]
        [else (lookup s (rest lom))]))

(define (project JSON)
  (cond [(empty? JSON) empty]
        [(cons? JSON)
         (cons (bus (lookup "lon" (object-members (first JSON)))
                         (lookup "lat" (object-members (first JSON)))
                         (lookup "heading" (object-members (first JSON))))
               (project (rest JSON)))]))

(define (parse x)
  (project (read-json/web url)))

(define (draw-lop lob)
  (foldr (lambda (p bk)
           (place-image (rotate (- 450 (bus-dir p)) sprite) (bus-lon p) (bus-lat p) bk)) bloomington-map lob))

(define (draw lop)
  (draw-lop (cartesian->screen->bus bloomington-view lop)))

(big-bang (parse url)
  [on-tick parse 3]
  [to-draw draw]
  [name "Bloomington Double Map in Racket"])
