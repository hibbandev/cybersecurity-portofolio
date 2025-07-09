# SIEM Implementation Lab Report

## Tujuan

- Membangun Sistem Monitoring Keamanan Terpusat (SIEM)
- Mendeteksi Ancaman dan Insiden Secara Real-Time
- Memberikan Visibilitas Melalui Dashboard

---

## Topologi

Client Host (Ubuntu):

- Wazuh Agent
- Filebeat (opsional)

  |
  | (data logs, integrity, auth, dll)
  v

SIEM Server (Ubuntu):

- Wazuh Manager
- Wazuh Indexer
- Wazuh Dashboard

---

## 3. Tools & Versi

| Komponen      | Versi           |
| ------------- | --------------- |
| OS Server     | Ubuntu 24.04    |
| SIEM          | Wazuh 4.7       |
| Elasticsearch | 8.x             |
| Kibana        | 8.x             |
| Client Agent  | Wazuh Agent 4.7 |

---

## Instalasi Wazuh Server

### Penerapan Sistem

- OS: Ubuntu 24.04 LTS (64-bit)
- Update repositori & upgrade
  `sudo apt update && sudo apt upgrade -y`

### Instal Wazuh Manager, Indexer, dan Dashboard

Menggunakan script resmi:

```bash
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash wazuh-install.sh -a
```

Skrip ini akan menginstal:

- wazuh-manager untuk analisis data dan rules.
- wazuh-indexer untuk storage (berbasis OpenSearch).
- wazuh-dashboard untuk visualisasi & manajemen.

### Konfigurasi Firewall (UFW)

Buka port standar untuk komunikasi agent & dashboard:

```bash
sudo ufw allow 1514/tcp # Port default agent
sudo ufw allow 55000/tcp # Port REST API
sudo ufw allow 5601/tcp # Port dashboard
sudo ufw reload
```

### Mengecek Status Service

Pastikan semua service berjalan:

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
```

### Akses Dashboard

- Buka browser ke:
  `https://<IP-Server>:5601`

- Login default:
  Username: admin
  Password: <password yang dioutput pada instalasi>

### Menyiapkan Agent Registration

Agar agent bisa register ke server:
`sudo /var/ossec/bin/manage_agents`

- Pilih A untuk menambahkan agen baru.
- Masukkan nama & IP agent.
- Salin key yang muncul, nanti digunakan di client (agent).

### Memeriksa Log Wazuh

Untuk troubleshooting:
`sudo tail -f /var/ossec/logs/ossec.log`

---

## Instalasi & Konfigurasi Wazuh Agent

### Persiapan

- OS: Ubuntu 24.04
- IP Client: 192.168.101.36
- IP Server (Wazuh Manager): 192.168.101.16
- Pastikan server Wazuh sudah berjalan (wazuh-manager, wazuh-indexer, wazuh-dashboard).

### Instalasi Wazuh Agent

Unduh & Install

```bash
curl -O https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb
sudo dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb
sudo apt-get install -f
```

### Konfigurasi Agent

Edit konfigurasi agar agent mengenali Wazuh Manager:
`sudo nano /var/ossec/etc/ossec.conf`

Pada bagian <client>:

```bash
<server>
  <address>192.168.101.11</address>
  <port>1514</port>
  <protocol>tcp</protocol>
</server>
```

### Daftarkan Agent ke Manager

Di client
Generate key agar agent bisa registrasi:

```bash
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

Di server
Lakukan verifikasi & daftarkan:

```bash
sudo /var/ossec/bin/manage_agents
#Pilih (A)dd
#Masukkan nama (misalnya Ubuntu) dan IP (any)
#Salin key yang muncul
```

Di client
Masukkan key:
`sudo /var/ossec/bin/agent-auth -m 192.168.101.11 -p 1515 -A Ubuntu`

### Verifikasi koneksi

Di server
`sudo /var/ossec/bin/agent_control -l`

Hasilnya:
`ID: 001, Name: Ubuntu, IP: any, Active`

### Uji coba Monitoring

Tes log
Buat entry ke /var/log/syslog:
`echo "Testing wazuh agent" | sudo tee -a /var/log/syslog`

Pantau di server
`sudo tail -f /var/ossec/logs/ossec.log`

---

## Kesimpulan

- Instalasi & konfigurasi Wazuh agent di server & client Ubuntu sukses.
- Agent aktif & terkoneksi ke manager.
- File integrity monitoring, rootcheck, syscollector, dan log monitoring berjalan.
- Hasil monitoring terlihat di dashboard, mendeteksi aktivitas sudo dan session PAM.
- Server SIEM Wazuh siap menerima data log dari client agent.
- Dashboard dapat digunakan untuk memonitor alert, integritas file, deteksi rootkit, analisis security policy, dan lainnya.

---

## Lampiran

- [Status Wazuh Manager](wazuh-manager.png)
- [Status Wazuh Indexer](wazuh-indexer.png)
- [Status Wazuh Dashboard](wazuh-dashboard.png)
- [Status Filebieat](filebeat.png)
- [Tampilan Login](tampilan-login.png)
- [Tampilan Dashboard Web](dashboard-web.png)
- [Tampilan Wazuh Agent](dashboard-wazuh-agent.png)
- [Log Ossec Client](client-osseclog.png)
- [Client Status](client-status.png)
- [Agent Control](agent-control.png)
- [Tampilan Security Alert](security-alert.png)

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**
LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
