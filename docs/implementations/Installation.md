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
curl -fsSL https://yesdrapt.chandhar-labs.com/yesdr.gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/yesdr-archive-keyring.gpg >/dev/null
```

####Add APT Source
```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/yesdr-archive-keyring.gpg] https://yesdrapt.chandhar-labs.com stable main" | sudo tee /etc/apt/sources.list.d/yesdr.list
sudo apt update
```

## Install YESDR with a Package Manager
```
sudo apt install yesdr
```

## YESDR Configuration
####Open the YESDR Core Network Configuration File 
```
sudo nano /opt/yesdr/core/config.yaml
```
Edit the required fields

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
      port: 9090   #YSM
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

  sbi:
    port: 29525
  
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
####Open the YESDR YBS Configuration File 
```
sudo nano /opt/yesdr/core/ybs.yaml
```
Edit the required fields

```yaml
ybs:
  ip: 192.168.1.118
  port: 21521          
  port1: 2152          
  phyport: 2136        
  phyMode: UDPTx #BPSKTx #UDPTx #      
  modType: BPSK        

core_network:
  yamf:
    ip: 192.168.1.106
    port1: 7070        

security:
  gnb_k_nasenc: "7365637265746b657931323334353637" 
  cp_key: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

user_plane:
  gtp:
    local_bind_port: 2152
    max_payload: 65536

stack:
  rlc:
    segment_size: 512

  pdcp:
    sn_start: 1
    iv_length: 8

  fec:
    trellis:
      constraint_length: 7
      generators: [133, 171]
    viterbi_depth: 35

timers:
  amf_timeout_sec: 5
  max_retries: 3
  pdu_session_expiry_sec: 3600

logging:
  enable: true
  level: DEBUG
  node_name: YBS
  log_dir: logs
  dashboard:
    ip: 127.0.0.1
    port: 5001


debug:
  print_pdcp: true
  print_rlc: true
  print_gtp: true
  print_phy: false
```
####Open the YESDR YUE Configuration File 
```
sudo nano /opt/yesdr/core/yue.yaml
```
Edit the required fields

```yaml
ue:
  IMEISV: '4901542032375186'
  amf_ue: '8000'
  guti: null
  imsi: '405869477770001'
  key_ue: 465b5ce8b199b49faa5f0a2ee238a6bc
  op_ue: eccbc87e4b5ce2fe28308fd9f2a7baf3
  phyMode: 2
  sqn_ue: 0000000001f8
ue_ip:
  data_type: Text
  ybs_ip: 192.168.1.118
  ybs_port: 21521
  yue_ip: 192.168.1.111
  yue_port: 5005
  yue_port1: 2152
ue_security:
  access_stratum:
    ciphering:
      128-NEA1:
        description: UE supports AS ciphering using SNOW 3G only
        id: 1
        name: SNOW_3G
    integrity:
      128-NIA1:
        description: UE supports AS integrity using SNOW 3G only
        id: 1
        name: SNOW_3G
  nas:
    ciphering:
      128-EEA1:
        description: UE supports NAS ciphering using SNOW 3G only
        id: 1
        name: SNOW_3G
    integrity:
      128-EIA1:
        description: UE supports NAS integrity using SNOW 3G only
        id: 1
        name: SNOW_3G
  pdcp:
    CP_KEY: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    test_key: 7365637265746b657931323334353637
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
Note: Instead of starting the UE using systemctl, launch the YESDR UE Control Panel using ``` yesdr-uegui ```
Click Register UE inside the control panel.  
After successful authentication and session setup:  
   - UE state changes from **Idle** to **Connected**.  
   - The allocated **UE IP address** becomes visible.  
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

## To Visualize Spectrum Information
Connect to [http://127.0.0.1:8052](http://127.0.0.1:8052)
## Uplink and DownLink Data Transfer 
To send data and receive from UE  
Connect to [http://127.0.0.1:8053](http://127.0.0.1:8053)  
To Send Downlink data  
Connect to [http://127.0.0.1:8054](http://127.0.0.1:8054)


## UNINSTALL / CLEAN REMOVE

#### Remove Package
```
sudo apt purge yesdr
sudo rm -rf /opt/yesdr
sudo rm /etc/apt/sources.list.d/yesdr.list
sudo rm /usr/share/keyrings/yesdr-archive-keyring.gpg
sudo apt update
```




