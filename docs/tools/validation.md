# Validation and Debugging

YESDR protocols can be validated using standard packet capture tools
together with the provided Wireshark dissectors.

---

## Validation Workflow

1. Capture traffic between YUE, YBS, and YCore
2. Save packets as PCAP
3. Load PCAP in Wireshark
4. Enable YACP / YSMP dissectors
5. Verify message sequences against YESDR TS documents

---

## Supported Protocols

- YACP (Access Control)
- YSMP (Spectrum Management)

