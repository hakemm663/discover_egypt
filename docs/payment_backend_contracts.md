# Payment Backend Contracts

All amounts are expected in **minor currency units** (`amount = dollars * 100`).

## `POST /payments/create-intent`
Creates a Stripe PaymentIntent for booking card checkout.

### Request
```json
{
  "amount": 14999,
  "currency": "usd",
  "customerId": "user_123",
  "description": "Travel booking payment"
}
```

### Response
```json
{
  "id": "pi_123",
  "client_secret": "pi_123_secret_abc",
  "status": "requires_payment_method",
  "requires_server_confirmation": true
}
```

## `POST /payments/confirm`
Confirms/fetches final status after PaymentSheet completion.

### Request
```json
{ "paymentIntentId": "pi_123" }
```

### Response
```json
{
  "id": "pi_123",
  "status": "succeeded"
}
```

## `POST /payments/wallet/charge`
Used in two modes:
- wallet debit for booking payments (`paymentMethod = "wallet"` + `bookingId`),
- wallet top-up intent creation (`purpose = "wallet_topup"`).

### Wallet debit request
```json
{
  "bookingId": "booking_123",
  "amount": 5000,
  "currency": "usd",
  "customerId": "user_123",
  "paymentMethod": "wallet"
}
```

### Wallet top-up request
```json
{
  "amount": 2500,
  "currency": "usd",
  "customerId": "user_123",
  "paymentMethod": "card",
  "purpose": "wallet_topup"
}
```

### Response (wallet debit)
```json
{
  "bookingId": "booking_123",
  "paymentId": "wal_txn_123",
  "status": "succeeded"
}
```

### Response (wallet top-up intent)
```json
{
  "id": "pi_456",
  "client_secret": "pi_456_secret_xyz",
  "status": "requires_payment_method",
  "requires_server_confirmation": true
}
```

## `POST /payments/cash-on-arrival`
Registers cash-on-arrival for reconciliation without card capture.

### Request
```json
{
  "bookingId": "booking_123",
  "amount": 9900,
  "currency": "usd",
  "paymentMethod": "cash",
  "status": "pending_cash_collection"
}
```

### Response
```json
{
  "bookingId": "booking_123",
  "paymentId": "cash_123",
  "status": "pending_cash_collection"
}
```
