# BankSecure - Sample Test Credentials & Testing Guide

This project includes pre-seeded test fixtures so you can test all features immediately without manual configuration.

---

## 1. Administrator Account
- **Portal URL**: [http://127.0.0.1:5000/admin/login](http://127.0.0.1:5000/admin/login)
- **Username**: `admin`
- **Password**: `admin123`
- **Capabilities**:
  - View overall transaction metrics and volume
  - View 7-day trend chart and status distribution donut chart
  - Monitor flagged suspicious attempts and fraud alerts
  - Inspect user accounts and toggle active/suspended status
  - Review immutable security audit trail logs

---

## 2. Pre-Seeded Client Accounts

### Client 1 (Default Test User)
- **Portal URL**: [http://127.0.0.1:5000/login](http://127.0.0.1:5000/login)
- **Email**: `john@example.com`
- **Password**: `User123!`
- **Cards Linked**:
  - Visa: `**** **** **** 4242` (Available: $6,845.50)
  - MasterCard: `**** **** **** 8821` (Available: $3,750.00)
- **Transactions**: Pre-populated with approved, declined, and suspicious historical transactions.

### Client 2 (Secondary Test User)
- **Email**: `emma@example.com`
- **Password**: `User123!`
- **Cards Linked**:
  - American Express: `**** **** **** 1005` (Available: $9,450.00)

---

## 3. How to Test Face Recognition & Anti-Fraud

1. **Register a New User with Live Webcam**:
   - Go to [http://127.0.0.1:5000/register](http://127.0.0.1:5000/register)
   - Enter your name, email, and password.
   - Click **"Activate Camera"**, position your face in the oval guide, and click **"Capture Face Profile"**.
   - Click **"Complete Registration & Enroll Face"**.
   - Your account is created with an enrolled 128-dimensional facial embedding and an automatic starter credit card!

2. **Test an Authorized Transaction (Match -> Approved)**:
   - Go to **"Make Payment"** (`/transaction/new`).
   - Select your credit card, amount (e.g. `$45.00`), and merchant.
   - Click **"Authenticate with Face ID & Pay"**.
   - Look directly at the webcam and click **"Verify Face & Pay"**.
   - The system checks liveness and compares your live face against your enrolled embedding.
   - When verified (&ge; 75% confidence), the transaction is **APPROVED**, funds are deducted, and a digital receipt is generated!

3. **Test an Unauthorized / Mismatch Attempt (Mismatch -> Blocked)**:
   - Have another person face the camera, or hold up an unrelated photo, or use the "Upload Test Face" button to submit a different face.
   - The system detects the biometric vector distance exceeds the threshold.
   - Transaction is **DECLINED** / **FLAGGED AS SUSPICIOUS**.
   - Funds are protected and zero balance is deducted.
   - An alert appears in the **Admin Dashboard** under **"Suspicious Transaction Attempt Detector"**.

4. **Test Resetting the Database**:
   - Run in terminal: `python seed_data.py`
   - Reinitializes all tables and fixtures cleanly.
