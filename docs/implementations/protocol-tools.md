# Protocol Analysis with Wireshark

This section explains how YESDR control-plane protocols can be viewed and analyzed
using **Wireshark**. To support debugging, validation, and education, official
Wireshark dissectors and example packet capture files are provided for selected
YESDR protocols.

!!! note
    The tools described here are **reference implementations** and are
    **non-normative** unless explicitly stated otherwise in the corresponding
    Technical Specification.

---

## Supported Protocols

Wireshark dissectors are currently available for the following YESDR protocols:

- **YACP** — YESDR Access Control Protocol  
- **YSMP** — YESDR Session Management Protocol  

Additional protocol dissectors may be added in future releases.

---

## Wireshark Dissector Overview

- Dissector language: **Lua**
- Compatible with standard Wireshark builds with Lua enabled
- Supports:
  - Offline packet capture (`.pcap`, `.pcapng`)
  - Live traffic capture over UDP/TCP

---

## Installing the Lua Dissectors

### Prerequisites

- Wireshark with Lua support (enabled by default in most installations)

### Installation Steps

1. Locate the Wireshark plugins directory:

    **Linux**
    ```bash
    ~/.local/lib/wireshark/plugins/
    ```

    **Windows**
    ```text
    C:\Users\<username>\AppData\Roaming\Wireshark\plugins\
    ```

    **macOS**
    ```bash
    ~/.local/lib/wireshark/plugins/
    ```

2. Copy the following dissector files into the plugins directory:

    
    `yacp.lua` — <a href="../../assets/dissectors/yacp.lua" download>Download</a>  
    `ysmp.lua` — <a href="../../assets/dissectors/ysmp.lua" download>Download</a>
    

3. Restart Wireshark

4. Verify installation:
   - Open **Analyze → Enabled Protocols**
   - Confirm that **YACP** and **YSMP** are listed

---

## Viewing YESDR Protocol Messages

### Using Example PCAP Files

Example packet capture files are provided for learning and validation.   
  **Sample PCAP File:** <a href="../../assets/dissectors/yesdr.pcapng" download>Download</a>


  

#### Steps

1. Open Wireshark
2. Load a capture file:  
   `yacp_example.pcap`  
   `ysmp_example.pcap`
3. Apply display filters:
   `GoTo Preferences -> Enabled Protocols -> HTTP --> Add Port "29525" in TCP Ports`  
   `yacp`  
   `ysmp`
   `http`
4. Expand protocol fields in the packet details pane to inspect:
   `Message types`  
   `Information Elements (IEs)`  
   `Identifiers and flags`  
   `Cause and status codes`
