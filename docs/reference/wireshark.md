# YESDR Wireshark Dissectors, Validation, and Tools

YESDR provides reference Wireshark dissectors and validation tools for its control‑plane protocols to support protocol inspection, debugging, conformance checking, and educational use. These implementations are aligned with the corresponding YESDR Technical Specifications (TS) and are intended as **reference implementations** for researchers, developers, and implementers.

---

## Supported Protocols

| Protocol | YESDR Specification | Dissector Language | Purpose |
|--------|---------------------|--------------------|---------|
| YACP | TS 04.001 | Lua | Access control and registration |
| YSMP | TS 04.002 | Lua | Spectrum management and control |

---

## YACP Dissector

**Protocol Name:** YESDR Access Control Protocol  
**Specification:** TS 04.001  

The YACP Wireshark dissector enables decoding and analysis of:

- Access and registration procedures  
- Information Elements (IEs)  
- Procedure and cause codes  
- Transaction identifiers and session context  

This dissector is primarily used to validate control‑plane signaling between user equipment, base stations, and the core network.

---

## YSMP Dissector

**Protocol Name:** YESDR Spectrum Management Protocol  
**Specification:** TS 04.002  

The YSMP Wireshark dissector enables decoding and analysis of:

- Spectrum sensing and reporting messages  
- Allocation, control, and coordination signaling  
- Interference indicators and occupancy fields  

This dissector supports spectrum‑aware experimentation, dynamic allocation, and AI‑assisted radio optimization.

---

## Validation and Debugging

YESDR protocols can be validated using standard packet capture tools in conjunction with the provided Wireshark dissectors. This enables systematic inspection of message formats, protocol behavior, and compliance with YESDR Technical Specifications.

---

## Validation Workflow

1. Capture traffic between **YUE**, **YBS**, and **YCore** components  
2. Save captured packets in **PCAP** format  
3. Enable the **YACP** and **YSMP** dissectors by keeping wireshark files in /lib/x86_64-linux-gnu/wireshark/plugins directory  
4. Load the PCAP file into **Wireshark**
5. Verify message sequences, field values, and procedures against the relevant **YESDR TS documents**  

This workflow supports protocol debugging, conformance testing, and reproducible experimentation.

---

## Reference Implementations

The Wireshark dissectors provided by YESDR serve as:

- Executable interpretations of YESDR Technical Specifications  
- Tools for validating protocol correctness and interoperability  
- Educational resources for understanding YESDR control‑plane behavior  

They are not intended as production implementations, but as transparent and extensible references for research, development, and standard evolution.

---

## Tool Summary

- **Wireshark Dissector Framework:** Protocol decoding and visualization  
- **PCAP‑Based Analysis:** Offline inspection and reproducible validation  
- **Specification‑Driven Verification:** Direct mapping to YESDR TS documents  
- **SDR and AI Integration:** Supports spectrum‑aware and AI‑driven experimentation  

