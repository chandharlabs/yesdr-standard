# YESDR System Architecture

The following architecture illustrates the end-to-end YESDR, including YUE, YBS, and YCore interactions.

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../assets/architecture/YesDR_Architecture.png"
    style="width:100%; height:auto; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>


---

## YesDR Components

| Term  | Full Form                 | Description |
|------|---------------------------|-------------|
| YUE  | YesDR User Equipment      | The end‑device or terminal used by the end user. |
| YBS  | YesDR Base Station        | Provides radio access and initial control signaling. |
| YSM  | YesDR Spectrum Monitor    | Dedicated unit that monitors spectrum usage in real time, identifies interference, and detects underutilized bands to support dynamic spectrum allocation via YCRF. |
| YCore| YesDR Core                | Centralized core network component responsible for control‑plane and user‑plane functions, orchestration, and integration with spectrum management through YCRF. |

## YesDR Core Functions

| Term  | Full Form                                      | Description |
|------|-----------------------------------------------|-------------|
| YAMF | YesDR Access and Mobility Management Function | Handles registration, access control, and mobility management. |
| YSMF | YesDR Session Management Function             | Manages IP session establishment, modification, and release. |
| YUPF | YesDR User Plane Function                     | Forwards and processes user‑plane traffic. |
| YNRF | YesDR Network Repository Function             | Provides service discovery and network function registration. |
| YUDM | YesDR Unified Data Management                 | Stores subscriber profiles, authentication data, and device information. |
| YAUSF| YesDR Authentication Service Function         | Performs identity verification and key agreement procedures. |
| YPCF | YesDR Policy Charging Function                | Applies policy and charging rules to sessions and traffic flows. |
| YNEF | YesDR Network Exposure Function               | Exposes network capabilities and services to external applications. |
| YNSSF| YesDR Network Slice Selection Function        | Selects and manages appropriate network slices for services. |
| YRMF | YesDR Radio Management Function               | Controls spectrum usage, power levels, and bandwidth allocation. |
| YCRF | YesDR Cognitive Radio Function                | Performs AI‑driven spectrum monitoring, learning, and adaptive optimization. |

## Control Protocols

| Protocol | Full Form                              | Description |
|---------|----------------------------------------|-------------|
| YACP    | YesDR Access Control Protocol          | Manages access control, authentication, and registration procedures. |
| YSMP    | YesDR Spectrum Management Protocol     | Coordinates spectrum sensing, allocation, and dynamic spectrum management. |

