# Penetration Testing Report: DVWA SQLi & XSSr Testing with Burp

## Tujuan

Menguji kerentanan SQL Injection dan XSS Reflection pada aplikasi DVWA menggunakan Burp Suite dan mengobservasi respon server terhadap input malicious.

---

## Target Pengujian

| Elemen           | Detail                |
| ---------------- | --------------------- |
| Nama Aplikasi    | DVWA                  |
| IP Target        | 192.168.56.106        |
| Fitur Diuji      | Form Page / SQLi Page |
| Tingkat Keamanan | Low                   |

---

## Tools dan Lingkungan

| Tool           | Versi               | Keterangan                |
| -------------- | ------------------- | ------------------------- |
| Burp Suite     | Community v2025.5.3 | Proxy & Tester            |
| Kali Linux     | 2025.2              | Sistem operasi utama      |
| Browser        | Firefox ESR         | Disetting proxy Burp      |
| Web App Target | DVWA                | Aplikasi rentan untuk tes |

---

## Langkah-Langkah Pengujian

### 1. Konfigurasi Awal

Kali Linux:

- Atur proxy browser ke `127.0.0.1:8080`

[Screenshot Proxy Kali Linux](setting-proxy.png)

- Import Sertifikat CA Burp ke browser
  - Jalankan Burp Suite
  - Buka browser, akses: `http://burp`
  - Download sertifikat: "CA Certificate"
  - Masuk ke:
    - Firefox > Settings > Privacy & Security > Certificates > View Certificates > Authorities
    - Klik Import
    - Pilih file sertifikat .cer
    - Centang “Trust this CA to identify websites”
    - Klik OK

Ubuntu (Target):

- Atur proxy browser ke `192.168.56.106:8080` (IP Kali Linux)

[Screenshot Proxy Ubuntu](proxy-target.png)

### 2. Intercept Request

- Buka brower `http://192.168.56.106/dvwa/`
- Login ke aplikasi DVWA
- Masuk ke bagian SQL Injection dan XSS Reflected
- Pastikan Intercept ON di Burp Suite
- Di kolom input, masukkan angka atau payload:
  - `1` untuk SQLi
  - `<script>alert(1)</script>` untuk XSSr
- Di Burp Suite akan terlihat request seperti ini:
  - `GET /dvwa/vulnerabilities/sqli/?id=1&Submit=Submit HTTP/1.1`
- Klik kanan, lalu klik Send to Repeater

### 3. Eksploitasi

Gunakan Repeater untuk uji payload:

- `1%27%20OR%20%271%27=%271%20` yang berarti `1' OR '1'='1`

[Screenshot Hasil SQL Injection](sqli.png)

- `%3Cscript%3Ealert%28%27Reflected+XSS%27%29%3C%2Fscript%3E` yang berarti `<script>alert('Reflected XSS')</script>`

[Screenshot Hasil XSS Reflected](xss.png)

---

## Analisis & Temuan

Kerentanan Ditemukan:

- SQL Injection memungkinkan bypass login
- Aplikasi tidak melakukan input sanitization

Impact:

- Penyerang bisa mengakses akun admin
- Potensi dump database dengan UNION SELECT

---

## Rekomendasi Mitigasi

- Terapkan prepared statements / parameterized queries
- Validasi dan filter input dari user
- Gunakan Web Application Firewall (WAF)

---

## Kesimpulan

Pengujian berhasil menemukan kerentanan SQL Injection dan XSS Reflected pada DVWA. Hal ini menunjukkan pentingnya validasi input dan penggunaan teknik secure coding untuk mencegah eksploitasi.

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**

LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
