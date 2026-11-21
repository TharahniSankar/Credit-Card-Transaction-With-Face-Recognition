# Credit Card Transaction System Based on Face Recognition Technology

![Project Status](https://img.shields.io/badge/Status-Completed-success)
![Python Version](https://img.shields.io/badge/Python-3.7%2B-blue)
![Framework](https://img.shields.io/badge/Backend-Flask-green)
![AI Biometrics](https://img.shields.io/badge/AI-OpenCV%20%7C%20face__recognition-orange)
![Frontend](https://img.shields.io/badge/Frontend-Bootstrap%205%20%7C%20JS-blueviolet)

A secure, zero-trust online credit card transaction system that uses real-time **facial recognition technology** and **anti-spoofing heuristics** to authenticate cardholders before approving payments.

---

## 📑 Table of Contents
1. [Project Overview](#project-overview)
2. [Key Features & Architecture](#key-features--architecture)
3. [Technology Stack](#technology-stack)
4. [Folder Structure](#folder-structure)
5. [Prerequisites & Installation](#prerequisites--installation)
6. [How to Run in Visual Studio Code](#how-to-run-in-visual-studio-code)
7. [Default Test Credentials & Testing Guide](#default-test-credentials--testing-guide)
8. [Security Features & Compliance](#security-features--compliance)
9. [GitHub Upload Instructions](#github-upload-instructions)

---

## 1. Project Overview

Credit card fraud and identity theft remain among the highest financial cybercrimes globally. Traditional payment gateways rely primarily on static credentials (card numbers, CVVs, passwords, and SMS OTPs) which can be intercepted, phished, or stolen.

This system introduces a **biometric zero-trust authentication layer**:
- Even if an attacker possesses the cardholder's 16-digit card number and details, **transactions are strictly blocked unless the live webcam face matches the account owner's enrolled biometric signature**.
- Facial embeddings are extracted as **128-dimensional vectors** using deep metric learning (`dlib` ResNet & OpenCV).
- Live camera frames pass through **anti-spoofing heuristics** (Laplacian variance blur check, Haar cascade eye & face alignment checks) to defeat 2D photo prints and screen playback attacks.

---

## 2. Key Features & Architecture

```
User Initiates Payment (Merchant & Amount)
                 │
                 ▼
       Select Credit Card
                 │
                 ▼
    Open Live Webcam Stream
                 │
                 ▼
 ┌───────────────────────────────┐
 │ Anti-Spoofing & Quality Check │ ──(Fails)──► Transaction Blocked (FAILED / SUSPICIOUS)
 │  - Eye & Facial Geometry      │
 │  - Laplacian Blur Variance    │
 └───────────────────────────────┘
                 │ (Passed)
                 ▼
 ┌───────────────────────────────┐
 │ 128-d Feature Vector Extracted│
 └───────────────────────────────┘
                 │
                 ▼
 ┌───────────────────────────────┐
 │ Euclidean Distance Comparison │ ──(Distance > 0.52)──► Mismatch Declined (Security Alert)
 │ Against Registered DB Vector  │
 └───────────────────────────────┘
                 │ (Match & Confidence >= 75%)
                 ▼
 ┌───────────────────────────────┐
 │ Transaction Approved          │
 │  - Balance Deducted           │
 │  - Digital Receipt Generated  │
 └───────────────────────────────┘
```

### Core Modules:
1. **User Registration**:
   - Register with Name, Email, Phone, and Password.
   - Interactive live webcam enrollment with oval viewfinder.
   - Saves 128-d biometric embedding securely in the database.
   - Automatically provides a $5,000 credit starter card for instant testing.
2. **User Login**:
   - Secure authentication with `Werkzeug` cryptographic password hashing.
   - Protected session management.
3. **Credit Card Management**:
   - Interactive visual credit cards with dynamic styling (Visa, MasterCard, Amex, RuPay).
   - Add new cards with 16-digit Luhn formatting and expiration checks.
   - **Zero CVV storage**; card numbers masked as `**** **** **** 1234`.
4. **Biometric Payment Module**:
   - Select card, enter merchant and amount.
   - Real-time webcam face scan modal with laser line animation.
   - Instant approval (&ge; 75% confidence) or rejection.
5. **Transaction Ledger & Digital Receipts**:
   - Filter by status (`Approved`, `Declined`, `Suspicious`) and search.
   - Interactive modal with printable digital receipts containing biometric stamps.
6. **Administrator Dashboard**:
   - Real-time KPIs (Total Users, Processed Volume, Blocked Fraud Attempts).
   - Interactive Chart.js visualizations (daily transaction trends and status donut chart).
   - **Suspicious Transaction Attempt Detector** for security personnel.
   - User account status management (Suspend / Activate).
   - System-wide security audit trail logs.

---

## 3. Technology Stack

- **Backend**: Python 3.7+ with Flask framework
- **Database**: SQLite (built-in, zero-setup) with optional MySQL compatibility
- **Face Recognition AI**: `face_recognition` (dlib ResNet-34) and `OpenCV` (`cv2`)
- **Frontend**: HTML5, CSS3, JavaScript (ES6+), Bootstrap 5.3, FontAwesome 6, Chart.js
- **Password Security**: Werkzeug PBKDF2 with SHA-256

---

## 4. Folder Structure

```
Online Shop/
│
├── app.py                     # Main Flask application entry point with all routes
├── config.py                  # System configuration (paths, security thresholds)
├── db.py                      # Database models, queries, masking & seed fixtures
├── face_engine.py             # OpenCV & face_recognition processing, anti-spoofing
├── schema.sql                 # SQL database table definitions
├── seed_data.py               # Database reinitialization utility
├── test_system.py             # Automated unit and integration test suite
│
├── static/
│   ├── css/
│   │   └── style.css          # Modern banking UI theme (navy/blue/light-grey)
│   ├── js/
│   │   ├── main.js            # General UI helpers, receipt modals & formatters
│   │   └── face_capture.js    # Camera stream, canvas snapshot & API dispatch
│   └── uploads/
│       └── faces/             # Secure storage for user face snapshots (.gitkeep)
│
├── templates/
│   ├── base.html              # Base layout with navbar, alerts, modals & footer
│   ├── index.html             # Professional landing page
│   ├── register.html          # Registration with live webcam face enrollment
│   ├── login.html             # Client login
│   ├── dashboard.html         # User dashboard & card summary
│   ├── cards.html             # Credit card management
│   ├── transaction_new.html   # Payment checkout & live face verification modal
│   ├── transactions.html      # Transaction history ledger & search
│   ├── profile.html           # User profile & Face ID re-enrollment
│   ├── admin_login.html       # Administrator portal sign-in
│   ├── admin_dashboard.html   # Admin command center with Chart.js analytics
│   ├── admin_users.html       # Registered users directory & status toggle
│   ├── admin_transactions.html# Full transaction ledger
│   ├── admin_security_logs.html # Security audit trail logs
│   ├── 404.html               # 404 error page
│   └── 500.html               # 500 server error page
│
├── sample_test_credentials.md # Quick test credentials & testing walkthrough
├── requirements.txt           # Python dependency requirements
├── .gitignore                 # GitHub ignore rules (secrets & images protected)
└── README.md                  # Comprehensive documentation
```

---

## 5. Prerequisites & Installation

### Step 1: Clone or Open Project in VS Code
Open your terminal or command prompt in the project root:
```bash
cd "d:\Online Shop"
```

### Step 2: Install Python Dependencies
```bash
pip install -r requirements.txt
```
> **Note for Windows Users**: On Windows, `dlib-bin` provides precompiled binary wheels for `dlib` without requiring CMake or Visual Studio C++ build tools.

### Step 3: Initialize Database & Seed Data
```bash
python seed_data.py
```
This automatically creates `bank_system.db` with sample users, linked credit cards, and historical transactions.

---

## 6. How to Run in Visual Studio Code

1. Open **VS Code**.
2. Go to **File -> Open Folder...** and select `d:\Online Shop`.
3. Open the built-in terminal (**Ctrl + `** or **Terminal -> New Terminal**).
4. Run the application:
   ```bash
   python app.py
   ```
5. You will see:
   ```
   =================================================================
    Credit Card Transaction System Based on Face Recognition
   =================================================================
    * Running on: http://127.0.0.1:5000
    * Default User: john@example.com / User123!
    * Admin Portal: http://127.0.0.1:5000/admin/login (admin / admin123)
   =================================================================
   ```
6. Open your web browser and navigate to:
   - **Client Portal**: [http://127.0.0.1:5000](http://127.0.0.1:5000)
   - **Admin Portal**: [http://127.0.0.1:5000/admin/login](http://127.0.0.1:5000/admin/login)

---

## 7. Default Test Credentials & Testing Guide

| Role | Username / Email | Password | Linked Cards | Notes |
|------|------------------|----------|--------------|-------|
| **Admin** | `admin` | `admin123` | N/A | Full monitoring & fraud dashboard |
| **User 1** | `john@example.com` | `User123!` | Visa, MasterCard | Enrolled demo account |
| **User 2** | `emma@example.com` | `User123!` | American Express | Secondary demo account |

### Running the Automated Test Suite:
```bash
python test_system.py
```
Runs 7 comprehensive automated tests verifying routes, cryptographic password hashing, vector distance calculations, and card limit validations.

---

## 8. Security Features & Compliance

- **Password Hashing**: PBKDF2-HMAC-SHA256 via Werkzeug security library.
- **Credit Card Data Protection**:
  - Raw card numbers are never stored in plaintext.
  - Numbers are irreversibly masked (`**** **** **** 1234`).
  - CVV codes are **never stored**.
- **Biometric Anti-Spoofing / Liveness**:
  - Image variance calculation (Laplacian) to detect screen moire patterns or blurry printouts.
  - Facial landmarks and eye presence confirmation using OpenCV Haar Cascades.
- **Intrusion & Anomaly Detection**:
  - Repeated failed biometric verification attempts trigger security flags.
  - Unrecognized face attempts are logged into the Admin Audit Trail.

---

## 9. GitHub Upload Instructions

The repository includes a carefully configured `.gitignore` that protects private biometric face images, local SQLite database files, compiled bytecode, and secrets.

To initialize git and push to your GitHub repository, execute the following commands in your terminal:

```bash
# 1. Initialize git repository
git init

# 2. Stage all project files (sensitive files are automatically ignored by .gitignore)
git add .

# 3. Commit the source code
git commit -m "Initial commit: Credit Card Transaction System with Face Recognition"

# 4. Rename default branch to main
git branch -M main

# 5. Link your GitHub remote repository (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/face-credit-card-transaction-system.git

# 6. Push to GitHub
git push -u origin main
```

---

## 📄 License
This project is developed for educational and security research purposes. All simulated credit card numbers are synthetic test numbers.
