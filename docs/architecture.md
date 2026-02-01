## <strong>YESDR System Architecture

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../images/yesdr_arch.png"
    style="width:80%; height:85%; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>


## <strong>YESDR Components

| Term  | Full Form                 | Description |
|------|---------------------------|-------------|
| YCore| YESDR Core                | Centralized core network component responsible for control‑plane and user‑plane functions, orchestration, and integration with spectrum management. |
| YBS  | YESDR Base Station        | Provides radio access and initial control signaling. |
| YSM  | YESDR Spectrum Monitor    | Monitors spectrum usage in real time, identifies interference, and detects underutilized bands to support dynamic spectrum allocation. |
| YUE  | YESDR User Equipment      | The end‑device or terminal used by the end user. |

## <strong>YESDR Core Functions

| Term  | Full Form                                      | Description |
|------|-----------------------------------------------|-------------|
| YAMF | YESDR Access and Mobility Management Function | Handles registration, access control, and mobility management. |
| YSMF | YESDR Session Management Function             | Manages IP session establishment, modification, and release. |
| YUPF | YESDR User Plane Function                     | Forwards and processes user‑plane traffic. |
| YNRF | YESDR Network Repository Function             | Provides service discovery and network function registration. |
| YUDM | YESDR Unified Data Management                 | Stores subscriber profiles, authentication data, and device information. |
| YAUSF| YESDR Authentication Service Function         | Performs identity verification and key agreement procedures. |
| YUDR | YESDR Unified Data Repository                 | Maintains subscription, policy, and network function-related data.|
| YPCF | YESDR Policy Charging Function                | Applies policy and charging rules to sessions and traffic flows. |
| YNSSF| YESDR Network Slice Selection Function        | Selects and manages appropriate network slices for services. |
| YRMF | YESDR Radio Management Function               | Controls spectrum usage, power levels, and bandwidth allocation. |
| YCRF | YESDR Cognitive Radio Function                | Performs AI‑driven spectrum monitoring, learning, and adaptive optimization. |

## <strong>Control Protocols

| Protocol | Full Form                              | Description |
|---------|----------------------------------------|-------------|
| YACP    | YesDR Access Control Protocol          | Manages access control, authentication, and registration procedures. |
| YSMP    | YesDR Spectrum Management Protocol     | Coordinates spectrum sensing, allocation, and dynamic spectrum management. |

## <strong>YESDR Message Sequence

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../images/Yesdr_sequence.png"
    style="width:100%; height:85%; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>
	
## <strong>YACP Packet Structure

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../images/yacp_str.png"
    style="width:100%; height:85%; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>

## <strong>YSMP Packet Structure

<div style="width:100%; margin:0; padding:0;">
  <img 
    src="../images/ysmp_str.png"
    style="width:100%; height:85%; display:block; margin-bottom:0.5rem;"
    loading="lazy">
</div>

## <strong>YESDR Access Control Protocol

| Msg Type | Message Name | IE Type | IE Name | Item Name | Size (bytes) |
|---------:|--------------|--------:|---------|-----------|--------------|
| 0x06 | YACPSetupRequest | 0x20 | GlobalNodeID | plmn_id | 3 |
|  |  |  |  | node_id | Variable |
|  |  | 0x21 | NodeName | node_name | Variable |
| 0x07 | YACPSetupResponse | 0x30 | YAMFName | yamf_name | Variable |
|  |  | 0x31 | ServedGUAMIList | plmn_id | 3 |
|  |  |  |  | yamf_region_id | 1 |
|  |  |  |  | yamf_set_id | 2 |
|  |  |  |  | yamf_pointer | 1 |
|  |  | 0x32 | RelativeYAMFCapacity | capacity | 1 |
|  |  | 0x33 | PLMNSupportList | sst | 1 |
| 0x08 | RadioResourceRequest | 0x40 | RadioResourceRequest | ybs_id | 3 |
|  |  |  |  | plmn_id | 3 |
|  |  |  |  | tac | 2 |
| 0x09 | RadioResourceResponse | 0x41 | RadioResourceResponse | yamf_id | 2 |
|  |  |  |  | bandwidth_mhz | 2 |
|  |  |  |  | frequency_mhz | 2 |
|  |  |  |  | power_dbm | 2 |
| 0x10 | NASRegistrationRequest | 0x55 | RAN-UE-NGAP-ID | ran_ue_ngap_id | 4 |
|  |  | 0x26 | NAS-PDU | nas_pdu | Variable |
|  |  | 0x79 | UserLocationInformation | plmn_id | 3 |
|  |  |  |  | nr_cell_id | 5 |
|  |  |  |  | tac | 3 |
|  |  | 0x5A | RRCEstablishmentCause | cause | 1 |
|  |  | 0x03 | AMFSetID | amf_set_id | 2 |
|  |  | 0x70 | UEContextRequest | ue_context_request | 1 |
| 0x11 | NASSecurityModeCommand | 0x60 | SecurityAlgorithms | encryption_algo | 1 |
|  |  |  |  | integrity_algo | 1 |
|  |  |  |  | imeisv_request | 1 |
|  |  | 0x61 | NASMessageContainer | nas_msg_container | Variable |
|  |  | 0x62 | GUTI | guti | Variable |
| 0x12 | NASSecurityModeComplete | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | gnb_ue_ngap_id | 4 |
|  |  | 0x70 | IMEISV | imeisv | Variable |
|  |  | 0x71 | EAPMessage | eap_message | Variable |
|  |  | 0x72 | AdditionalSecCapabilities | additional_sec_caps | Variable |
| 0x13 | NASRegistrationAccept | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | gnb_ue_ngap_id | 4 |
|  |  | 0x80 | TAIList | tai_list | Variable |
|  |  | 0x82 | DRXParameters | drx_params | Variable |
|  |  | 0x83 | RegistrationStatus | reg_status | 1 |
| 0x28 | IdentityRequest | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | ran_ue_ngap_id | 4 |
|  |  | 0x26 | NAS-PDU | nas_identity_req | Variable |
| 0x30 | IdentityResponse | 0x50 | UE Identity | value | Variable |
|  |  | 0x51 | UE Security Capabilities | value | Variable |
|  |  | 0x52 | Requested NSSAI | sst/sd | Variable |
|  |  | 0x53 | PLMN ID | plmn | 3 |
|  |  | 0x54 | Serving Network Name | network_name | Variable |
|  |  | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | gnb_ue_ngap_id | 4 |
| 0x29 | DownlinkNASTransport (Auth Req) | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | ran_ue_ngap_id | 4 |
|  |  | 0x26 | NAS-PDU | nas_auth_req | Variable |
| 0x2A | UplinkNASTransport (Auth Resp) | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | ran_ue_ngap_id | 4 |
|  |  | 0x26 | NAS-PDU | nas_auth_resp | Variable |
| 0x20 | PDUSessionResourceSetupRequest | 0x0A | AMF-UE-NGAP-ID | amf_ue_ngap_id | 4 |
|  |  | 0x55 | RAN-UE-NGAP-ID | ran_ue_ngap_id | 4 |
|  |  | 0x62 | GUTI | guti | Variable |
|  |  | 0x66 | TEID | teid | 4 |
|  |  | 0x4A | PDUSessionResourceList | pdu_session_id | 1 |
|  |  |  |  | nas_dnn | Variable |
|  |  |  |  | s_nssai | Variable |
|  |  |  |  | qos | Variable |
|  |  |  |  | ssc_mode | 1 |
|  |  | 0x86 | PDUSessionType | pdu_type | 1 |
|  |  | 0x6E | UEAggregateMaximumBitRate | bitrate_dl_ul | 8 |
| 0x21 | PDUSessionResourceSetupResponse | 0x4B | PDUSessionResourceListSURes | pdu_session_id | 1 |
|  |  |  |  | gtp_ip | 4 |
|  |  |  |  | gtp_teid | 4 |
|  |  |  |  | qos_flow_id | 1 |
|  |  |  |  | ue_ip | 4 |

## <strong>YESDR Spectrum Management Protocol

| Msg Type | Message Name | IE Type | IE Name | Field Name | Size (bytes) |
|---------:|--------------|--------:|---------|------------|--------------|
| 0x10 | YSMSetupRequest | 0x01 | YSM ID | ysm_id | 4 |
|  |  | 0x02 | Location | location | Variable |
|  |  | 0x03 | Capabilities | capabilities | 1 |
|  |  | 0x04 | Scan Bands | band_list | 2×N |
|  |  | 0x05 | FFT Size | fft_size | 2 |
|  |  | 0x06 | Max Power | max_power | 2 |
| 0x11 | YSMSetupResponse | 0x11 | Status Code | status | 1 |
|  |  | 0x12 | Response Message | response_msg | Variable |
|  |  | 0x13 | Assigned Frequency | assigned_freq | 2 |
|  |  | 0x14 | Assigned Bandwidth | assigned_bw | 2 |
|  |  | 0x15 | Allocated Power | allocated_power | 1 |
|  |  | 0x20 | Radio Resource Info | resource_info | 4 |
| 0x31 | YSMReport | 0x40 | Timestamp | timestamp | Variable |
|  |  | 0x41 | Start Frequency | start_freq | 4 |
|  |  | 0x42 | End Frequency | end_freq | 4 |
|  |  | 0x43 | Occupancy | occupancy | 1 |
|  |  | 0x44 | Number of Measurements | num_measurements | 2 |
|  |  | 0x45 | Decision | decision | Variable |


