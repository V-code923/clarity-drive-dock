;; Constants  
(define-constant min-score u1)
(define-constant max-score u5)

;; Data maps
(define-map user-ratings
  { user: principal }
  { total-score: uint, total-ratings: uint }
)

;; Public functions
(define-public (rate-user (user principal) (score uint))
  (asserts! (and (>= score min-score) (<= score max-score)) (err u100))
  (let ((current-rating (default-to 
    { total-score: u0, total-ratings: u0 }
    (map-get? user-ratings { user: user }))))
    (map-set user-ratings
      { user: user }
      {
        total-score: (+ (get total-score current-rating) score),
        total-ratings: (+ (get total-ratings current-rating) u1)
      }
    )
    (ok true))
)
