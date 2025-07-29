# Penetration Testing Report: Nmap Scanning

## Tujuan

Melakukan scanning port, service, dan deteksi OS pada target lab virtual (Metasploitable2) untuk mengidentifikasi potensi celah keamanan.

---

## Target

- **IP Address:** `192.168.56.104`
- **OS:** Linux (Metasploitable2 vulnerable machine)

---

## Metode & Tools

- **Tools:** Nmap (di Kali Linux)
- **Command:**

```bash
nmap -sV -A 192.168.56.104 -oN nmap_scan.txt
```

## Hasil Scan

| Port     | State | Service     | Version                         |
| -------- | ----- | ----------- | ------------------------------- |
| 21/tcp   | open  | ftp         | vsftpd 2.3.4 (anon allowed)     |
| 22/tcp   | open  | ssh         | OpenSSH 4.7p1 Debian 8ubuntu1   |
| 23/tcp   | open  | telnet      | Linux telnetd                   |
| 25/tcp   | open  | smtp        | Postfix smtpd (SSLv2 supported) |
| 53/tcp   | open  | domain      | ISC BIND 9.4.2                  |
| 80/tcp   | open  | http        | Apache 2.2.8 (Ubuntu DAV/2)     |
| 111/tcp  | open  | rpcbind     | RPC #100000                     |
| 139/tcp  | open  | netbios-ssn | Samba smbd 3.X - 4.X            |
| 445/tcp  | open  | netbios-ssn | Samba smbd 3.0.20-Debian        |
| 512/tcp  | open  | exec        | netkit-rsh rexecd               |
| 513/tcp  | open  | login       | OpenBSD/Solaris rlogind         |
| 514/tcp  | open  | shell       | Netkit rshd                     |
| 1099/tcp | open  | java-rmi    | GNU Classpath grmiregistry      |
| 1524/tcp | open  | bindshell   | Metasploitable root shell       |
| 2049/tcp | open  | nfs         | NFS 2-4                         |
| 2121/tcp | open  | ftp         | ProFTPD 1.3.1                   |
| 3306/tcp | open  | mysql       | MySQL 5.0.51a-3ubuntu5          |
| 5432/tcp | open  | postgresql  | PostgreSQL 8.3.0 - 8.3.7        |
| 5900/tcp | open  | vnc         | VNC protocol 3.3                |
| 6000/tcp | open  | X11         | access denied                   |
| 6667/tcp | open  | irc         | UnrealIRCd                      |
| 8009/tcp | open  | ajp13       | Apache Jserv (1.3)              |
| 8180/tcp | open  | http        | Apache Tomcat/Coyote JSP 1.1    |

OS Detection :

- Device type: general purpose
- Running: Linux 2.6.X
- OS CPE: cpe:/o:linux:linux_kernel:2.6

---

## Analisis Kerentanan

Berdasarkan hasil scanning, ditemukan beberapa layanan yang rawan dieksploitasi:

| Service       | Risiko Utama                                   | Catatan                                   |
| ------------- | ---------------------------------------------- | ----------------------------------------- |
| vsftpd 2.3.4  | Backdoor smiley `:)` yang spawn shell          | CVE-2011-2523                             |
| UnrealIRCd    | Remote code execution via backdoor IRC command | CVE-2010-2075                             |
| Samba 3.0.20  | Remote command execution (user map script)     | CVE-2007-2447                             |
| MySQL 5.0.51a | Exploitasi credential lemah / default          | Versi sangat usang                        |
| Telnet, rsh   | Auth plaintext, mudah sniffing & brute force   | Tidak dienkripsi sama sekali              |
| vsftpd        | Anonymous login diaktifkan                     | Dapat enumerasi / download file anonim    |
| Postfix       | SSLv2 masih aktif                              | Cipher deprecated, rawan MITM             |
| Apache 2.2.8  | Versi lama, rentan LFI / RFI                   | Banyak CVE kritikal                       |
| Tomcat 5.5    | Default credentials `tomcat:tomcat`            | Sangat sering dijumpai di Metasploitable2 |
| Bindshell     | Port 1524 terbuka dengan root shell langsung   | Tanpa autentikasi                         |

---

## Rekomendasi Mitigasi

| Area           | Rekomendasi                                                   |
| -------------- | ------------------------------------------------------------- |
| Port           | Tutup port tidak perlu via firewall (`iptables` / `ufw`)      |
| FTP            | Nonaktifkan anonymous login, update ke vsftpd terbaru         |
| SSH            | Update OpenSSH, batasi IP, gunakan fail2ban                   |
| Telnet & rsh   | Nonaktifkan, ganti dengan SSH                                 |
| Postfix        | Disable SSLv2, enforce TLS1.2+                                |
| Samba          | Update ke Samba 4+, batasi share                              |
| MySQL, PgSQL   | Update DB, audit user/password, matikan remote jika tak perlu |
| Apache, Tomcat | Update ke versi stabil terbaru, hapus user default            |
| UnrealIRCd     | Update atau ganti, audit IRC config                           |
| NFS            | Batasi host, gunakan squash root                              |
| OS Kernel      | Update kernel minimal 5.x, hardening sesuai benchmark CIS     |

---

## Post Exploitation & Potensi Aksi

Jika attacker berhasil exploit:

- **Privilege escalation**: meski sudah root di Metasploitable2, ini bisa terjadi jika target environment berbeda.
- **Data exfiltration**: dump file /etc/shadow, database, file user.
- **Persistence**: pasang cronjob / ssh key.
- **Pivoting**: gunakan box ini untuk scan internal jaringan.

---

## Kesimpulan

Target Metasploitable2 secara sengaja memiliki banyak celah keamanan dan layanan lama, cocok untuk lab penetration testing. Namun di lingkungan nyata, kondisi ini sangat berbahaya. Semua service perlu di-hardening, diupdate, atau dimatikan jika tidak diperlukan.

---

## Lampiran

- [Full scan result](nmap_scan.txt)
- [Screenshot terminal output](screenshot-nmap.png)

---

## _Ditulis oleh:_

**Ibnu Hibban Dzulfikri**

LinkedIn: https://www.linkedin.com/in/ibnu-hibban-dzulfikri-b51a7824a

---
