# YESDR Installation and Service Management

This describes how to install, use, manage, and remove YESDR using
the official APT package repository. YESDR follows standard Debian/Ubuntu package
and service management conventions.

---
## Install MongoDB


####Add MongoDB Repository

```
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg  
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

####Install MongoDB
```
sudo apt update 
sudo apt install -y mongodb-org 
```

#### Enable & Start MongoDB
```
sudo systemctl enable mongod
sudo systemctl start mongod
```
####Verify
```
sudo systemctl status mongod
```
Note: It should be active.

## Getting YESDR Repository

#### Add GPG Key

```
curl -fsSL https://package.yesdr-standard.org/yesdr.gpg | sudo gpg --dearmor -o /usr/share/keyrings/yesdr-archive-keyring.gpg
```

####Add APT Source
```
echo "deb [signed-by=/usr/share/keyrings/yesdr-archive-keyring.gpg] https://package.yesdr-standard.org stable main" | sudo tee /etc/apt/sources.list.d/yesdr.list
sudo apt update
```

## Install YESDR with a Package Manager
```
sudo apt install yesdr
```

## YESDR Configuration
```yaml
core_network:
    ysmf:
      ip: 192.168.1.105
      port: 29525 #SBI 
      port1: 8805  #PFCP
    ypcf:
      ip: 192.168.1.125
      port: 29525 #SBI 
    yausf:
      ip: 192.168.1.103
      port: 29525 #SBI 
    yupf:
      ip: 192.168.1.119
      port1: 29525 #SBI 
      port2: 2152 #GTP
      port3: 8805  #PFCP
    ynrf:
      ip: 192.168.1.107
      port: 29525 #SBI 
    yamf:
      ip : 192.168.1.106
      port: 9090   #YSM   adding port 2 for sbi
      port1: 7070  #YACP(YBS)
      port2: 29525 #SBI
    yrmf:
      ip : 192.168.1.108
      port: 29525 #SBI 
      mode: sdr   # sdr or nosdr
    ycrf:
      ip: 192.168.1.102
      port: 29525 #SBI 
    yudm:
      ip: 192.168.1.104
      port: 29525 #SBI 

  yue:
    ip: 192.168.1.111
    port: 5005
    port1: 2152

  sbi:
    port: 29525
  
  ybs:
    ip: 192.168.1.118
    port: 21521
    port1: 2152
    phyport: 2136
    phyMode: UDPTx # UDPTx, OFDMTx, BPSKTx
    modType: BPSK # BPSK, QPSK, 16-QAM, 64-QAM
  
  ycrfdb:
    ip: 127.0.0.1
    port: 5432
    user: ysm_user
    password: ysm_report
    database: ysm_db

  chSender:
    dataType: Text #1. Text, 2 .Image
  
  logging:
    level: DEBUG
    file: logs/core.log
```
## Network Interface Configuration

####Open the IP Configuration File
```
sudo nano /opt/yesdr/config/ip.conf
```
Note: Replace the Interface Name  
Example: INTERFACE=wlx30de4b16212b. Replace it with your actual network interface name.

## Start YESDR Services

#### Configuration
```
sudo systemctl start yesdr-ipconfig
sudo systemctl start yesdr-web
```
#### Core Network
```
sudo systemctl start yesdr-ynrf
sudo systemctl start yesdr-yamf
sudo systemctl start yesdr-yrmf
sudo systemctl start yesdr-ycrf
sudo systemctl start yesdr-ysm
sudo systemctl start yesdr-yausf
sudo systemctl start yesdr-yudm
sudo systemctl start yesdr-ypcf
sudo systemctl start yesdr-ysmf
sudo systemctl start yesdr-yupf
```

#### RAN and UE
```
sudo systemctl start yesdr-ybs
sudo systemctl start yesdr-yue
```

#### Check Status of All Services
```
systemctl status yesdr-ipconfig
systemctl status yesdr-ynrf
systemctl status yesdr-yamf
systemctl status yesdr-yausf
systemctl status yesdr-yudm
systemctl status yesdr-ypcf
systemctl status yesdr-ycrf
systemctl status yesdr-ysmf
systemctl status yesdr-yupf
systemctl status yesdr-ybs
systemctl status yesdr-ysm
systemctl status yesdr-yrmf
systemctl status yesdr-yue
systemctl status yesdr-web
```

####Stop YESDR Services
```
sudo systemctl stop yesdr-yue
sudo systemctl stop yesdr-ybs
sudo systemctl stop yesdr-yupf
sudo systemctl stop yesdr-ysmf
sudo systemctl stop yesdr-ypcf
sudo systemctl stop yesdr-yudm
sudo systemctl stop yesdr-yausf
sudo systemctl stop yesdr-ysm
sudo systemctl stop yesdr-ycrf
sudo systemctl stop yesdr-yrmf
sudo systemctl stop yesdr-yamf
sudo systemctl stop yesdr-ynrf
```


####View Logs for All YESDR Services
```
journalctl -u yesdr-ipconfig -f
journalctl -u yesdr-ynrf -f
journalctl -u yesdr-yamf -f
journalctl -u yesdr-yausf -f
journalctl -u yesdr-yudm -f
journalctl -u yesdr-ypcf -f
journalctl -u yesdr-ycrf -f
journalctl -u yesdr-ysmf -f
journalctl -u yesdr-yupf -f
journalctl -u yesdr-ybs -f
journalctl -u yesdr-ysm -f
journalctl -u yesdr-yrmf -f
journalctl -u yesdr-yue -f
journalctl -u yesdr-web -f
```

## Register Subscriber Information

Connect to [http://127.0.0.1:8051](http://127.0.0.1:8051) and login with admin account.
```
Username : admin  
Password : admin
```
<!--
## To Visualize Spectrum Information
Connect to [http://127.0.0.1:8052](http://127.0.0.1:8052)
## To Visualize Spectrum Information
To send data and receive from UE
Connect to [http://127.0.0.1:8053](http://127.0.0.1:8053)
To Send Downlink data
Connect to [http://127.0.0.1:8054](http://127.0.0.1:8054)
-->

## UNINSTALL / CLEAN REMOVE

#### Remove Package
```
sudo apt purge yesdr
sudo rm -rf /opt/yesdr
sudo rm /etc/apt/sources.list.d/yesdr.list
sudo rm /usr/share/keyrings/yesdr-archive-keyring.gpg
sudo apt update
```




