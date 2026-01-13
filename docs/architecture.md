# YESDR System Architecture


## YesDR Components

| Term  | Full Form                 | Description |
|------|---------------------------|-------------|
| YUE  | YESDR User Equipment      | The end‑device or terminal used by the end user. |
| YBS  | YESDR Base Station        | Provides radio access and initial control signaling. |
| YSM  | YESDR Spectrum Monitor    | Monitors spectrum usage in real time, identifies interference, and detects underutilized bands to support dynamic spectrum allocation. |
| YCore| YESDR Core                | Centralized core network component responsible for control‑plane and user‑plane functions, orchestration, and integration with spectrum management. |

## YesDR Core Functions

| Term  | Full Form                                      | Description |
|------|-----------------------------------------------|-------------|
| YAMF | YESDR Access and Mobility Management Function | Handles registration, access control, and mobility management. |
| YSMF | YESDR Session Management Function             | Manages IP session establishment, modification, and release. |
| YUPF | YESDR User Plane Function                     | Forwards and processes user‑plane traffic. |
| YNRF | YESDR Network Repository Function             | Provides service discovery and network function registration. |
| YUDM | YESDR Unified Data Management                 | Stores subscriber profiles, authentication data, and device information. |
| YAUSF| YESDR Authentication Service Function         | Performs identity verification and key agreement procedures. |
| YPCF | YESDR Policy Charging Function                | Applies policy and charging rules to sessions and traffic flows. |
| YNEF | YESDR Network Exposure Function               | Exposes network capabilities and services to external applications. |
| YNSSF| YESDR Network Slice Selection Function        | Selects and manages appropriate network slices for services. |
| YRMF | YESDR Radio Management Function               | Controls spectrum usage, power levels, and bandwidth allocation. |
| YCRF | YESDR Cognitive Radio Function                | Performs AI‑driven spectrum monitoring, learning, and adaptive optimization. |

## Control Protocols

| Protocol | Full Form                              | Description |
|---------|----------------------------------------|-------------|
| YACP    | YesDR Access Control Protocol          | Manages access control, authentication, and registration procedures. |
| YSMP    | YesDR Spectrum Management Protocol     | Coordinates spectrum sensing, allocation, and dynamic spectrum management. |

## End-to-End Architecture

The following figure illustrates the end-to-end YESDR architecture, including YUE, YBS, and YCore interactions.

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../assets/architecture/YesDR_Architecture.png"
    style="width:80%; height:85%; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>


