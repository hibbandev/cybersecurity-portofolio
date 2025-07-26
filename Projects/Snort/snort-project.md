# Snort-based IDS/IPS Lab Project

## Deskripsi Proyek

Implementasi sistem Intrusion Detection System (IDS) dan Intrusion Prevention System (IPS) menggunakan **Snort** dalam lingkungan virtual. Proyek ini menunjukkan keterampilan praktis dalam mengonfigurasi sistem keamanan jaringan dan mendeteksi ancaman secara real-time.

## Tools & Lingkungan

- OS: Ubuntu Server 24.04 (Snort)
- Kali Linux (sebagai attacker)
- Snort: Versi 2.9.20
- VirtualBox (untuk simulasi jaringan)

---

## IP Adrdess

- Kali Linux: `192.168.56.103`
- Ubuntu Server 24.04: `192.168.56.105`

## Langkah Implementasi

### 1. Setup Virtual Lab

- Buat 2 VM:
  - VM 1: Ubuntu Server 24.04 (Snort)
  - VM 2: Kali Linux (attacker)
- Atur adapter ke **Host-Only** agar bisa saling terhubung.

### 2. Instalasi Snort

```bash
sudo apt update
sudo apt install -y snort
```

- Verifikasi:

```bash
snort -V
```

### 3. Menjalankan Snort dalam IDS Mode

```bash
sudo snort -i enp0s3 -A console -c /etc/snort/snort.conf -l /var/log/snort
```

- Penjelasan:
  - `-i`: interface (contoh: enp0s3)
  - `-A console`: tampilkan alert ke terminal
  - `-c`: konfigurasi utama
  - `-l`: folder untuk log

---

## Skenario Uji Serangan

### 1. ICMP Ping

```bash
ping -c 5 192.168.56.105
```

- [Ping Target](ping.png)

### 2. Port Scan

```bash
nmap -sS 192.168.56.105
```

-[Scan Target](nmap.png)

---

## Penulisan Custom Rule

- Buat Rules di sudo nano /etc/snort/rules/local.rules:

```bash
# Deteksi ping ICMP
alert icmp any any -> any any (msg:"ICMP Detected"; sid:1000001; rev:1;)

# Drop koneksi SSH
drop tcp any any -> any 22 (msg:"DROP SSH Connection"; sid:1000002; rev:1;)

# Deteksi akses HTTP
alert tcp any any -> any 80 (msg:"HTTP Access Detected"; sid:1000003; rev:1;)
```

- [Rules](rules.png)

---

## Kesimpulan

- Proyek ini menunjukkan keterampilan dasar hingga menengah dalam keamanan jaringan:
  - Menyiapkan sistem IDS/IPS berbasis Snort.
  - Mengembangkan custom rules untuk mendeteksi dan mencegah serangan.
  - Menguji efektivitas rule menggunakan skenario nyata.

---

## Lampiran

- [Output via Terminal](output-ids.png)
- [Output Log Attacker](log-attacker.png)

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**
LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
