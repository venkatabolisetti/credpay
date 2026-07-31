-- =====================================================================
-- CREDPAY CAPSTONE PROJECT - PostgreSQL Database Schema
-- =====================================================================
-- Database: credpay
-- Tables:   users, cards, payments
-- Notes:    Schema only. No application code is included here.
--           Card numbers are stored masked for safety in this demo.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Clean start (safe to re-run). Drop in dependency order.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS cards    CASCADE;
DROP TABLE IF EXISTS users    CASCADE;

-- ---------------------------------------------------------------------
-- Table: users
-- Purpose: Stores registered users for the User Module (Register/Login)
-- ---------------------------------------------------------------------
CREATE TABLE users (
    id            BIGSERIAL    PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,            -- store a HASH, never plain text
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------
-- Table: cards
-- Purpose: Credit cards belonging to a user (Add Card / View Cards)
-- ---------------------------------------------------------------------
CREATE TABLE cards (
    id           BIGSERIAL    PRIMARY KEY,
    user_id      BIGINT       NOT NULL,
    card_holder  VARCHAR(100) NOT NULL,
    card_number  VARCHAR(25)  NOT NULL,             -- demo: store masked e.g. '**** **** **** 1234'
    card_network VARCHAR(20),                       -- e.g. VISA, MASTERCARD, RUPAY
    expiry_month SMALLINT     NOT NULL CHECK (expiry_month BETWEEN 1 AND 12),
    expiry_year  SMALLINT     NOT NULL CHECK (expiry_year >= 2024),
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_cards_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

-- Index to quickly list all cards for a given user
CREATE INDEX idx_cards_user_id ON cards (user_id);

-- ---------------------------------------------------------------------
-- Table: payments
-- Purpose: Simulated payments (amount + UPI ID + status)
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    id          BIGSERIAL      PRIMARY KEY,
    user_id     BIGINT         NOT NULL,
    card_id     BIGINT,                              -- optional: card used for the payment
    amount         NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    upi_id         VARCHAR(100)   NOT NULL,
    transaction_id VARCHAR(30)    UNIQUE,            -- e.g. TXN20260624001 (set by payment-service)
    status         VARCHAR(20)    NOT NULL DEFAULT 'PENDING'
                   CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),
    created_at     TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_payments_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_payments_card
        FOREIGN KEY (card_id) REFERENCES cards (id) ON DELETE SET NULL
);

-- Index to quickly fetch a user's payment history
CREATE INDEX idx_payments_user_id ON payments (user_id);

-- =====================================================================
-- Sample Data
-- =====================================================================

-- Users (password_hash values are placeholders representing hashed passwords)
INSERT INTO users (full_name, email, password_hash) VALUES
    ('Asha Verma',  'asha@example.com',  '$2a$10$hashPlaceholderForAsha000000000000000000000000'),
    ('Rohit Kumar', 'rohit@example.com', '$2a$10$hashPlaceholderForRohit00000000000000000000000');

-- Cards (linked to the users above)
INSERT INTO cards (user_id, card_holder, card_number, card_network, expiry_month, expiry_year) VALUES
    (1, 'Asha Verma',  '**** **** **** 1234', 'VISA',       8,  2027),
    (1, 'Asha Verma',  '**** **** **** 5678', 'MASTERCARD', 11, 2026),
    (2, 'Rohit Kumar', '**** **** **** 9012', 'RUPAY',      3,  2028);

-- Payments (linked to users and optionally a card)
INSERT INTO payments (user_id, card_id, amount, upi_id, status) VALUES
    (1, 1, 1500.00, 'asha@okhdfcbank',  'SUCCESS'),
    (1, 2,  299.50, 'asha@okhdfcbank',  'SUCCESS'),
    (2, 3, 4999.99, 'rohit@oksbi',      'PENDING');

-- =====================================================================
-- Quick verification queries (optional)
-- =====================================================================
-- SELECT * FROM users;
-- SELECT * FROM cards;
-- SELECT * FROM payments;
