# YESDR – Implementation Status

## 1. YESDR Core Network

| Component / Function | Completed | To Be Done |
|--------------------|-----------|------------|
| Core Network Functions (YNRF, YAMF, YCRF, YRMF, YAUSF, YUDM, YUDR, YPCF, YSMF, YUPF, YNSSF) | Implemented as independent modules | Optimization and full inter-function validation |
| SBI Interface | FastAPI-based SBI implemented | Standard compliance refinement |
| Inter-Module Communication | FastAPI-based communication | Error recovery and robustness |
| YACP Interface | Implemented for YBS communication | Initial four protocol messages |
| YSMP Interface | Implemented for YSM communication | Full message coverage |
| Spectrum Scanning | Spectrum scanning implemented | Advanced scanning strategies |
| Resource Allocation | Allocation based on frequency occupancy | Policy-driven dynamic allocation |
| Authentication | 5G-AKA implemented | NAS-level enhancements |
| Key Management | User database with keys | Secure key lifecycle management |
| Subscriber Data | Data retrieval from YUDR | Full synchronization with central DB |
| Policy Control (YPCF) | Policy reporting and modification | Advanced policy enforcement |
| User Plane Control | PFCP with YUPF implemented | Failure recovery handling |
| Uplink / Downlink | TEID-based handling implemented | QoS-aware routing |
| Database | PostgreSQL implemented | MongoDB as central database |
| Heartbeat Monitoring | Basic heartbeat support | Failure-based cleanup |
| IP Routing | – | To be implemented |

---

## 2. YESDR Protocol Stack

| Protocol / Feature | Completed | To Be Done |
|-------------------|-----------|------------|
| YACP | Core messages implemented | First four protocol messages |
| YSMP | Setup, response, report | Full protocol coverage |
| GTP | Uplink and downlink | Dynamic source IP handling |
| PFCP | Heartbeat, association request/response | UPF failure detection |
| Security | 5G-AKA implemented | Encryption & integrity protection |
| Message Modification | Basic support | Improved modification handling |
| Wireshark Dissector | Generated and functional | Complete message coverage |
| NAS Signaling | – | Full NAS implementation |

---

## 3. YESDR RAN Layers

| Layer | Completed | To Be Done |
|------|-----------|------------|
| PHY | BPSK downlink (User Plane) | BPSK downlink control plane |
| PHY | – | BPSK uplink (Control & User Plane) |
| MAC | CRC, segmentation | Scheduling, MAC headers |
| RLC | Basic framework | AM, TM, UM modes |
| PDCP | Basic processing | NAS-based encryption (Kupenc) |
| SDAP | – | QoS flow mapping |
| RRC | – | Full RRC signaling |
| FEC | Coding and decoding | Performance optimization |
| Security | Hard-coded key (initial) | Dynamic key usage |

---

## 4. YBS (YESDR Base Station)

| Feature | Completed | To Be Done |
|-------|-----------|------------|
| Protocol Stack | Implemented | Validation with full core |
| Control Messages | – | First four protocol messages |
| Core Integration | Partial | Full end-to-end testing |

---

## 5. YUE (YESDR User Equipment)

| Feature | Completed | To Be Done |
|--------|-----------|------------|
| UE Registration | GUI-based registration | NAS & RRC integration |
| Uplink Data | Text transmission | Image and video support |
| Downlink Data | Registration and reception | QoS-aware reception |
| Security | Basic authentication | GUTI mapping |
| GUI | Functional GUI | Feature-rich UI |

---

## 6. Advanced Network Features

| Feature | Completed | To Be Done |
|-------|-----------|------------|
| Handover | – | Intra- and inter-cell handover |
| AMF–AMF Communication | – | Full support |
| gNB–gNB Communication | – | Xn-like interface |
| Mobility Management | – | End-to-end mobility handling |

---

## 7. AI / ML / DL Capabilities

| Feature | Completed | To Be Done |
|-------|-----------|------------|
| Spectrum Sensing | Spectrum sensing from 600 MHz to 6 GHz | AI-asssted accuracy optimization and multi-band correlation |
| Signal Energy Detection | Real-time energy-based sensing | Adaptive thresholding |
| Modulation Classification | – | AI/ML-based modulation classification |
| Channel Prediction | – | ML/DL-based channel quality prediction |
| Channel ON/OFF Prediction | – | Traffic-aware channel ON–OFF duration prediction |
| Model Deployment | – | Edge deployment (MEC / SDR embedded) |
| Real-Time Inference | – | Low-latency inference optimization |
| Visualization | Basic plots | AI-driven spectrum occupancy maps |



---

## 8. Tools & Packaging

| Tool / Feature | Completed | To Be Done |
|---------------|-----------|------------|
| Wireshark Visibility | Protocol dissectors | Extended coverage |
| Packaging | `.deb` package | Installer automation |
| GUI Tools | Basic visualization | Unified management GUI |
