-- Database Schema for Credit Card Transaction System Based on Face Recognition Technology
-- Compatible with SQLite and MySQL

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    face_encoding TEXT,               -- JSON serialized 128-dimensional vector
    face_image_path TEXT,             -- Relative path to user face snapshot
    is_active INTEGER DEFAULT 1,      -- 1 = Active, 0 = Suspended
    failed_face_attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS credit_cards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    cardholder_name TEXT NOT NULL,
    card_number_masked TEXT NOT NULL, -- e.g. '**** **** **** 4242'
    card_number_hash TEXT NOT NULL,   -- SHA256 of full number
    last4 TEXT NOT NULL,              -- Last 4 digits
    card_network TEXT NOT NULL,       -- Visa, MasterCard, Amex, Discover, RuPay
    expiry_month TEXT NOT NULL,       -- MM
    expiry_year TEXT NOT NULL,        -- YYYY
    card_limit REAL DEFAULT 5000.00,
    available_balance REAL DEFAULT 5000.00,
    is_primary INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id TEXT UNIQUE NOT NULL, -- e.g. 'TXN-20261121-7A3F'
    user_id INTEGER NOT NULL,
    card_id INTEGER NOT NULL,
    merchant_name TEXT NOT NULL,
    category TEXT NOT NULL,              -- Shopping, Dining, Electronics, Travel, Utilities
    amount REAL NOT NULL,
    status TEXT NOT NULL,                -- 'SUCCESS', 'FAILED', 'SUSPICIOUS'
    failure_reason TEXT,
    face_match_score REAL DEFAULT 0.0,   -- Confidence percentage (0 to 100)
    face_verified INTEGER DEFAULT 0,     -- 1 = Verified, 0 = Not verified
    liveness_checked INTEGER DEFAULT 0,  -- 1 = Passed, 0 = Failed
    ip_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (card_id) REFERENCES credit_cards (id)
);

CREATE TABLE IF NOT EXISTS admin_users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT DEFAULT 'Security Administrator',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS security_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_type TEXT NOT NULL,            -- 'LOGIN', 'FACE_ENROLL', 'FACE_VERIFY_SUCCESS', 'FACE_VERIFY_FAIL', 'SUSPICIOUS_ALERT'
    user_id INTEGER,
    details TEXT,
    ip_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
