# YesDR Wireshark Dissectors

YesDR provides reference Wireshark dissectors for its control-plane
protocols to support protocol inspection, debugging, validation,
and educational use.

The dissectors are aligned with the corresponding YesDR Technical
Specifications and are provided as **reference implementations**.

---

## Supported Protocols

| Protocol | YesDR Specification | Dissector Language |
|--------|---------------------|--------------------|
| YACP | TS 04.001 | Lua |
| YSMP | TS 04.002 | Lua |

---

## YACP Dissector

**Protocol Name:** YesDR Access Control Protocol  
**Specification:** TS 04.001  

The YACP dissector enables decoding of:
- Access and registration messages
- Information Elements (IEs)
- Procedure and cause codes
- Transaction identifiers

---

## YSMP Dissector

**Protocol Name:** YesDR Spectrum Management Protocol  
**Specification:** TS 04.002  

The YSMP dissector enables decoding of:
- Spectrum sensing reports
- Allocation and control messages
- Interference and occupancy fields
