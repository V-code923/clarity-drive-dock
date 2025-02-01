;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-ride-not-found (err u101))
(define-constant err-invalid-status (err u102))

;; Data structures
(define-map rides
  { ride-id: uint }
  {
    driver: principal,
    origin: (string-ascii 50),
    destination: (string-ascii 50),
    seats: uint,
    price: uint,
    departure-time: uint,
    status: (string-ascii 10)
  }
)

(define-map bookings
  { ride-id: uint, passenger: principal }
  {
    status: (string-ascii 10),
    payment-status: (string-ascii 10)
  }
)

;; Data variables
(define-data-var ride-nonce uint u0)

;; Public functions
(define-public (create-ride (origin (string-ascii 50)) 
                          (destination (string-ascii 50))
                          (seats uint)
                          (price uint)
                          (departure-time uint))
  (let ((ride-id (var-get ride-nonce)))
    (map-set rides
      { ride-id: ride-id }
      {
        driver: tx-sender,
        origin: origin,
        destination: destination,
        seats: seats,
        price: price,
        departure-time: departure-time,
        status: "OPEN"
      }
    )
    (var-set ride-nonce (+ ride-id u1))
    (ok ride-id))
)

(define-public (book-ride (ride-id uint))
  (let ((ride (unwrap! (map-get? rides { ride-id: ride-id }) (err err-ride-not-found))))
    (asserts! (is-eq (get status ride) "OPEN") (err err-invalid-status))
    (map-set bookings
      { ride-id: ride-id, passenger: tx-sender }
      {
        status: "BOOKED",
        payment-status: "PENDING"
      }
    )
    (ok true))
)
