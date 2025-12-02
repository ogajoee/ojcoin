;; OJCoin - a simple fungible token example
;; - fixed total supply minted to the contract deployer
;; - basic transfer and balance tracking
;; - no further minting or burning

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-ZERO-AMOUNT u102)

;; total supply of OJCoin (e.g. 1_000_000 units with 6 decimals implied externally)
(define-constant OJCOIN-TOTAL-SUPPLY u1000000000000)

;; data variables
(define-data-var total-supply uint u0)

;; balances: principal -> uint
(define-map balances
  { owner: principal }
  { balance: uint })

;; internal helper to get balance or u0
(define-read-only (get-balance (owner principal))
  (default-to u0
    (get balance (map-get? balances { owner: owner }))))

;; initialize total supply and mint to tx-sender (deployer)
(define-public (initialize)
  (begin
    (if (is-eq (var-get total-supply) u0)
        (begin
          (var-set total-supply OJCOIN-TOTAL-SUPPLY)
          (map-set balances { owner: tx-sender } { balance: OJCOIN-TOTAL-SUPPLY })
          (ok true))
        (err ERR-NOT-AUTHORIZED))))

;; transfer tokens from tx-sender to recipient
(define-public (transfer (amount uint) (recipient principal))
  (begin
    (if (is-eq amount u0)
        (err ERR-ZERO-AMOUNT)
        (let
          (
            (sender tx-sender)
            (sender-balance (get-balance sender))
          )
          (if (>= sender-balance amount)
              (begin
                (map-set balances { owner: sender } { balance: (- sender-balance amount) })
                (let ((recipient-balance (get-balance recipient)))
                  (map-set balances { owner: recipient } { balance: (+ recipient-balance amount) }))
                (ok true))
              (err ERR-INSUFFICIENT-BALANCE))))))

;; read-only: get balance of an owner
(define-read-only (balance-of (owner principal))
  (ok (get-balance owner)))

;; read-only: total supply
(define-read-only (get-total-supply)
  (ok (var-get total-supply)))
