;; Stackride Rides Contract
(define-data-var ride-id uint u0)
(define-map Rides 
    { ride-id: uint } 
    { rider: principal, driver: principal, amount: uint, status: (string-ascii 20) }
)

(define-public (book-ride (rider principal) (driver principal) (amount uint))
    (let ((current-id (var-get ride-id)))
        (try! (stx-transfer? amount rider driver))
        (map-insert Rides 
            { ride-id: current-id } 
            { rider: rider, driver: driver, amount: amount, status: "booked" }
        )
        (var-set ride-id (+ current-id u1))
        (ok current-id)
    )
)

(define-read-only (get-ride (id uint))
    (match (map-get? Rides { ride-id: id })
        ride (ok ride)
        (err u1)
    )
)