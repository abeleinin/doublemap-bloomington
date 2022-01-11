#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/json)
(require lang/posn)

(define url "http://iub.doublemap.com/map/v2/buses")
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

; Convert one type of unit to another 
(define (convert a1 b1 a2 b2 a)
  (/ (+ (* b1 (- a2 a)) (* b2 (- a a1))) (- a2 a1)))

; Convert Bus coordinates to height and width of screen 
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

; Look up values from JSON dictionary
(define (lookup s lom)
  (cond [(empty? lom) (error "Error")]
        [(string=? (member-name (first lom)) s)
         (member-value (first lom))]
        [else (lookup s (rest lom))]))

; Get buses lon, lat, and angle of direction
(define (project JSON)
  (cond [(empty? JSON) empty]
        [(cons? JSON)
         (cons (bus (lookup "lon" (object-members (first JSON)))
                    (lookup "lat" (object-members (first JSON)))
                    (lookup "heading" (object-members (first JSON))))
               (project (rest JSON)))]))

; Call API to update bus position
(define (parse x)
  (project (read-json/web url)))

; Draw the list of buses onto a background image
(define (draw-lop lob)
  (foldr (lambda (p bk)
           (place-image (rotate (- 450 (bus-dir p)) sprite) (bus-lon p) (bus-lat p) bk)) bloomington-map lob))

; Draw the converted bus values onto the background image
(define (draw lop)
  (draw-lop (cartesian->screen->bus bloomington-view lop)))

; Initialize the animation
(big-bang (parse url)
  [on-tick parse 3]
  [to-draw draw]
  [name "Bloomington DoubleMap in Racket"])
