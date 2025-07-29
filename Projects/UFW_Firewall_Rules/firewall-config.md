# UFW Firewall Implementation

## Project Overview

- **Nama Project:** Implementasi Firewall dengan UFW
- **OS / Environment:** Ubuntu 24.04
- **Tujuan:** Mengamankan server dari koneksi tidak sah dengan mengatur akses port menggunakan UFW (Uncomplicated Firewall).

---

## Instalasi UFW

```bash
sudo apt update
sudo apt install ufw
```

---

## Mengecek status UFW

```bash
sudo ufw status verbose
```

Biasanya jika fresh install statusnya inactive.

---

## Default Policies

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

- Incoming: Ditolak secara default untuk mencegah akses tidak sah.
- Outgoing: Diizinkan secara default agar server tetap dapat mengakses internet / update.

---

## Allowed Rules

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

---

## Denied Rules

```bash
sudo ufw deny 23/tcp
```

---

## Firewall Status

```bash
sudo ufw status verbose
```

Output:

- Status: active
- Logging: on (low)
- Default: deny (incoming), allow (outgoing), disabled (routed)
- New profiles: skip

| Port | Protocol | From          | Action   | Description            |
| ---- | -------- | ------------- | -------- | ---------------------- |
| 22   | TCP      | Anywhere      | ALLOW IN | SSH remote access      |
| 80   | TCP      | Anywhere      | ALLOW IN | HTTP web server        |
| 443  | TCP      | Anywhere      | ALLOW IN | HTTPS secure web       |
| 23   | TCP      | Anywhere      | DENY IN  | Block Telnet           |
| 22   | TCP (v6) | Anywhere (v6) | ALLOW IN | SSH remote access IPv6 |
| 80   | TCP (v6) | Anywhere (v6) | ALLOW IN | HTTP web server IPv6   |
| 443  | TCP (v6) | Anywhere (v6) | ALLOW IN | HTTPS secure web IPv6  |
| 23   | TCP (v6) | Anywhere (v6) | DENY IN  | Block Telnet IPv6      |

---

## Logging

```bash
sudo ufw logging on
```

- Level default: low
- Logging penting untuk memonitor aktivitas mencurigakan.

---

## Maintenance Commands

| Task                             | Command                        |
| -------------------------------- | ------------------------------ |
| Menghapus rule tertentu          | `sudo ufw delete <nomor_rule>` |
| Reset semua konfigurasi UFW      | `sudo ufw reset`               |
| Menonaktifkan firewall sementara | `sudo ufw disable`             |
| Mengaktifkan kembali firewall    | `sudo ufw enable`              |

---

## Lampiran

- [Allow deny rules](allow-deny-rules.png)
- [Firewall status](firewall-status.png)
- [Screenshot tes akses port](tes-nmap.png)

---

## Kesimpulan

- Server kini lebih aman dengan hanya membuka port layanan penting.
- Logging aktif untuk monitoring aktivitas firewall.

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**

LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
