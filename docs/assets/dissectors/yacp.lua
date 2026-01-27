-- YACP Wireshark Dissector with NAS message support (fixed: readable top-level IE names + no duplicate IE printing)
local yacp_proto = Proto("YACP", "Yet Another Control Protocol")
-- Top-level fields
local f_version = ProtoField.uint8("yacp.version", "Version", base.DEC)
local f_msg_type = ProtoField.uint8("yacp.msg_type", "Message Type", base.HEX)
local f_payload_len = ProtoField.uint16("yacp.payload_len", "Payload Length", base.DEC)
-- Information Element fields
local f_ie_type = ProtoField.uint8("yacp.ie_type", "IE Type", base.HEX)
local f_ie_len = ProtoField.uint16("yacp.ie_len", "IE Length", base.DEC)
local f_ie_value = ProtoField.bytes("yacp.ie_value", "IE Value")
local f_nas_identity_type = ProtoField.uint8("yacp.nas.identity_type", "5GS Identity Type", base.DEC, {
    [1] = "SUCI",
    [2] = "5G-GUTI",
    [3] = "IMEI",
    [4] = "IMEISV",
    [5] = "TMSI"
})
f_pdu_session_id = ProtoField.uint8("yacp.pdu_session_id", "PDU Session ID", base.DEC)
f_gtp_ip = ProtoField.ipv4("yacp.gtp_ip", "GTP Tunnel IP")
f_gtp_teid = ProtoField.uint32("yacp.gtp_teid", "GTP-TEID", base.HEX)
f_gtp_port = ProtoField.uint16("yacp.gtp_port", "GTP Tunnel Port", base.DEC)
f_qos_flow_id = ProtoField.uint8("yacp.qfi", "QoS Flow Identifier", base.DEC)
f_ue_ip = ProtoField.ipv4("yacp.ue_ip", "UE IP Address")
-- NAS fields (single definitions only)
local f_nas_5gs_reg_type = ProtoField.uint8("yacp.nas.5gs_reg_type", "5GS Registration Type", base.HEX)
local f_nas_for_bit = ProtoField.bool("yacp.nas.for", "Follow-On Request (FOR)", 8, nil, 0x80)
local f_nas_reg_type_val = ProtoField.uint8("yacp.nas.reg_type_val", "Registration Type", base.DEC, {[1]="Initial registration", [2]="Mobility registration"}, 0x07)
local f_nas_ksi = ProtoField.uint8("yacp.nas.ksi", "NAS Key Set Identifier (KSI)", base.HEX, nil, 0x07)
local f_nas_tsc = ProtoField.uint8("yacp.nas.tsc", "Type of Security Context (TSC)", base.HEX, nil, 0x08)
local f_nas_mobile_identity = ProtoField.bytes("yacp.nas.mobile_identity", "5GS Mobile Identity")
local f_nas_mcc = ProtoField.string("yacp.nas.mcc", "Mobile Country Code (MCC)")
local f_nas_mnc = ProtoField.string("yacp.nas.mnc", "Mobile Network Code (MNC)")
local f_nas_amf_region_id = ProtoField.uint8("yacp.nas.amf_region_id", "AMF Region ID", base.HEX)
local f_nas_amf_set_id = ProtoField.uint16("yacp.nas.amf_set_id", "AMF Set ID", base.HEX)
local f_nas_amf_pointer = ProtoField.uint8("yacp.nas.amf_pointer", "AMF Pointer", base.HEX)
local f_nas_5g_tmsi = ProtoField.uint32("yacp.nas.5g_tmsi", "5G-TMSI", base.HEX)
local f_nas_ue_sec_capability = ProtoField.bytes("yacp.nas.ue_sec_capability", "UE Security Capability")
local f_nas_supi = ProtoField.string("yacp.nas.supi", "SUPI")
local f_nas_sec_caps = ProtoField.bytes("yacp.nas.security_capabilities", "UE Security Capabilities")
local f_nas_req_nssai = ProtoField.bytes("yacp.nas.requested_nssai", "Requested NSSAI")
local f_nas_plmn_id = ProtoField.string("yacp.nas.plmn_id", "PLMN ID")
local f_nas_enc_algo = ProtoField.uint8("yacp.nas.encryption_algo", "Encryption Algorithm", base.HEX)
local f_nas_int_algo = ProtoField.uint8("yacp.nas.integration_algo", "Integrity Algorithm", base.HEX)
local f_nas_imeisv_req = ProtoField.bool("yacp.nas.imeisv_request", "IMEISV Request")
local f_nas_nas_msg_container = ProtoField.bytes("yacp.nas.nas_message_container", "NAS Message Container")
local f_nas_guti = ProtoField.string("yacp.nas.guti", "GUTI")
local f_teid = ProtoField.uint32("yacp.teid", "TEID", base.HEX)
local f_nas_imeisv = ProtoField.string("yacp.nas.imeisv", "IMEISV")
local f_nas_eap_msg = ProtoField.bytes("yacp.nas.eap_message", "EAP Message")
local f_nas_add_sec_caps = ProtoField.bytes("yacp.nas.additional_security_capabilities", "UE Additional Security Capabilities")
local f_nas_tai_list = ProtoField.bytes("yacp.nas.tai_list", "TAI List")
local f_nas_drx_params = ProtoField.bytes("yacp.nas.drx_parameters", "DRX Parameters")
local f_nas_pdu = ProtoField.bytes("yacp.nas.pdu_session_request", "NAS PDU Session Request")
local f_nas_pdu_type = ProtoField.uint8("yacp.nas.pdu_session_request.pdu_type", "PDU Session Type", base.DEC)
local f_nas_ssc_mode = ProtoField.uint8("yacp.nas.pdu_session_request.ssc_mode", "SSC Mode", base.DEC)
local f_nas_dnn = ProtoField.string("yacp.nas.pdu_session_request.dnn", "Data Network Name (DNN)")
local f_nas_s_nssai = ProtoField.bytes("yacp.nas.pdu_session_request.s_nssai", "S-NSSAI")
local f_nas_qos = ProtoField.bytes("yacp.nas.pdu_session_request.qos", "Requested QoS Parameters")
local f_nas_rand = ProtoField.bytes("yacp.nas.rand", "Authentication Parameter RAND")
local f_nas_autn = ProtoField.bytes("yacp.nas.autn", "Authentication Parameter AUTN")
local f_nas_abba = ProtoField.bytes("yacp.nas.abba", "ABBA (NAS)")
local f_nas_serving_network_name = ProtoField.string("yacp.nas.serving_network", "Serving Network Name")
f_nas_msg_type = ProtoField.uint8("yacp.nas.msg_type", "NAS Message Type", base.HEX)
f_nas_sec_hdr_type = ProtoField.uint8("yacp.nas.security_header_type", "Security Header Type", base.DEC, nil, 0xF0)
f_nas_epd = ProtoField.uint8("yacp.nas.epd", "Extended Protocol Discriminator", base.HEX)
local f_amf_ue_ngap_id = ProtoField.uint32("yacp.amf_ue_ngap_id", "AMF UE NGAP ID", base.DEC)
local f_gnb_ue_ngap_id = ProtoField.uint32("yacp.gnb_ue_ngap_id", "RAN UE NGAP ID", base.DEC)
local f_pdu_session_id = ProtoField.uint8("yacp.pdu_session_id", "PDU Session ID", base.DEC)
local f_nas_epd = ProtoField.uint8("yacp.nas.ext_proto_disc", "Extended Protocol Discriminator", base.HEX)
local f_nas_sec_hdr_type = ProtoField.uint8("yacp.nas.sec_hdr_type", "Security Header Type", base.HEX)
local f_nas_msg_type = ProtoField.uint8("yacp.nas.msg_type", "NAS Message Type", base.HEX)
local f_nas_dnn = ProtoField.string("yacp.nas.dnn", "DNN")
local f_nas_qos = ProtoField.bytes("yacp.nas.qos", "QoS")
local f_nas_s_nssai = ProtoField.bytes("yacp.nas.s_nssai", "S-NSSAI")
-- PDUSessionType
local f_pdu_session_type = ProtoField.uint8("yacp.pdu_session_type", "PDU Session Type", base.DEC,
    {
        [0] = "IPv4",
        [1] = "IPv6",
        [2] = "IPv4v6",
        [3] = "Unstructured",
        [4] = "Ethernet"
    })
-- NGAP/embedded fields
local f_amf_ue_ngap_id = ProtoField.uint32("yacp.amf_ue_ngap_id", "AMF-UE-NGAP-ID", base.DEC)
local f_gnb_ue_ngap_id = ProtoField.uint32("yacp.gnb_ue_ngap_id", "gnb-ue-ngap-id", base.DEC)
local f_pdu_session_id = ProtoField.uint8("yacp.pdu_session_id", "PDU Session ID", base.DEC)
local f_gtp_ip = ProtoField.ipv4("yacp.gtp_ip", "GTP Tunnel Address")
local f_gtp_teid = ProtoField.uint32("yacp.gtp_teid", "GTP Tunnel TEID", base.HEX)
local f_gtp_port = ProtoField.uint16("yacp.gtp_port", "GTP Tunnel Port", base.DEC)
local f_qos_flow_id = ProtoField.uint8("yacp.qos_flow_id", "QoS Flow Identifier", base.DEC)
local f_procedure_code = ProtoField.uint8("yacp.procedure_code", "Procedure Code", base.DEC, {[29]="PDUSessionResourceSetup"})
local f_criticality = ProtoField.uint8("yacp.criticality", "Criticality", base.DEC, {[0]="reject", [1]="ignore", [2]="notify"})
local f_ie_id = ProtoField.uint8("yacp.ie_id", "IE ID", base.DEC, {
    [10]="AMF-UE-NGAP-ID",
    [85]="gnb-ue-ngap-id",
    [75]="PDUSessionResourceSetupListSURes"
})
yacp_proto.fields = {
    f_version, f_msg_type, f_payload_len,
    f_ie_type, f_ie_len, f_ie_value,
    -- NAS fields
    f_nas_supi, f_nas_sec_caps, f_nas_req_nssai, f_nas_plmn_id,
    f_nas_enc_algo, f_nas_int_algo, f_nas_imeisv_req,
    f_nas_nas_msg_container, f_nas_imeisv, f_nas_eap_msg, f_nas_add_sec_caps,
    f_nas_tai_list, f_nas_guti, f_nas_drx_params,
    f_nas_pdu, f_nas_pdu_type, f_nas_ssc_mode, f_nas_dnn,
    f_nas_s_nssai, f_nas_qos, f_amf_ue_ngap_id, f_gnb_ue_ngap_id,
    f_pdu_session_id, f_gtp_ip, f_gtp_teid, f_gtp_port, f_qos_flow_id,
    f_procedure_code, f_criticality, f_ie_id,
    f_nas_5gs_reg_type, f_nas_for_bit, f_nas_reg_type_val,
    f_nas_ksi, f_nas_tsc, f_nas_mobile_identity,
    f_nas_mcc, f_nas_mnc, f_nas_amf_region_id,
    f_nas_amf_set_id, f_nas_amf_pointer, f_nas_5g_tmsi,
    f_nas_ue_sec_capability, f_nas_identity_type,
    f_nas_rand, f_nas_autn, f_nas_abba,
    f_nas_msg_type, f_nas_sec_hdr_type, f_nas_epd, f_pdu_session_type, f_ue_ip, f_teid
}
-- Helper to decode BCD MCC/MNC
local function decode_bcd(bytes)
    local str = ""
    for i = 0, bytes:len() - 1 do
        local b = bytes(i,1):uint()
        local d1 = bit32.band(b, 0x0F)
        local d2 = bit32.band(bit32.rshift(b, 4), 0x0F)
        if d1 < 10 then str = str .. tostring(d1) end
        if d2 < 10 then str = str .. tostring(d2) end
    end
    return str
end
-- Helper to decode PLMN ID from 3 bytes BCD
local function decode_plmn(plmn_bytes)
    if plmn_bytes:len() < 3 then return "Invalid" end
    local b1, b2, b3 = plmn_bytes(0,1):uint(), plmn_bytes(1,1):uint(), plmn_bytes(2,1):uint()
    local mcc = string.format("%d%d%d",
        bit32.band(b1,0x0F),
        bit32.rshift(bit32.band(b1,0xF0),4),
        bit32.band(b2,0x0F))
    local mnc_digit3 = bit32.rshift(bit32.band(b2,0xF0),4)
    local mnc = ""
    if mnc_digit3 == 0xF then -- 2-digit MNC
        mnc = string.format("%d%d", bit32.band(b3,0x0F), bit32.rshift(bit32.band(b3,0xF0),4))
    else -- 3-digit MNC
        mnc = string.format("%d%d%d", bit32.band(b3,0x0F), bit32.rshift(bit32.band(b3,0xF0),4), mnc_digit3)
    end
    return string.format("MCC=%s MNC=%s", tostring(mcc), tostring(mnc))
end

-- Map top-level IE hex -> friendly name (used for Items that are not the PDUSession List)
local TOP_IE_NAMES = {
    [0x0A] = "AMF-UE-NGAP-ID",
    [0x55] = "gnb-ue-ngap-id",
    [0x86] = "PDU Session Type",
    [0x4A] = "PDUSessionResourceSetupListSUReq",
    [0x6E] = "UE-AMBR",
    [0x62] = "GUTI",
    [0x20] = "YBS IP / GlobalNodeID"
}

function yacp_proto.dissector(buffer, pinfo, tree)
    if buffer:len() < 4 then
        return
    end
    pinfo.cols.protocol = "YACP"
    local version = buffer(0,1):uint()
    local msg_type = buffer(1,1):uint()
    local payload_len = buffer(2,2):uint()
    local msg_type_name = "Unknown"
    if msg_type == 0x06 then
        msg_type_name = "YACPSetupRequest"
    elseif msg_type == 0x07 then
        msg_type_name = "YACPSetupResponse"
    elseif msg_type == 0x08 then
        msg_type_name = "RadioResourceRequest"
    elseif msg_type == 0x09 then
        msg_type_name = "RadioResourceResponse"
    elseif msg_type == 0x10 then
        msg_type_name = "NASRegistrationRequest"
    elseif msg_type == 0x11 then
        msg_type_name = "NASSecurityModeCommand"
    elseif msg_type == 0x12 then
        msg_type_name = "NASSecurityModeComplete"
    elseif msg_type == 0x13 then
        msg_type_name = "NASRegistrationAccept"
    elseif msg_type == 0x28 then
        msg_type_name = "IdentityRequest"
    elseif msg_type == 0x30 then
        msg_type_name = "Identity Response"
    elseif msg_type == 0x29 then
        msg_type_name = "DownlinkNASTransport, Authentication request"
    elseif msg_type == 0x2A then
        msg_type_name = "UplinkNASTransport, Authentication Response"
    elseif msg_type == 0x20 then
        msg_type_name = "PDUSessionResourceSetupRequest"
    elseif msg_type == 0x21 then
        msg_type_name = "PDUSessionResourceSetupResponse"
    end
    pinfo.cols.info:set(msg_type_name)
    local subtree = tree:add(yacp_proto, buffer(), "YACP Protocol Data")
    subtree:add(f_version, buffer(0,1))
    subtree:add(f_msg_type, buffer(1,1)):append_text(" (" .. msg_type_name .. ")")
    subtree:add(f_payload_len, buffer(2,2))
    local offset = 4
    local grouped = subtree:add(msg_type_name)
    local ies = grouped:add("protocolIEs: multiple items")
    local ie_idx = 0

    -- store top-level IE 0x20 (YBS IP) if present (used later to prefer override)
    local top_ie_0x20 = nil

    while offset < buffer:len() do
        if offset + 3 > buffer:len() then break end
        local ie_type = buffer(offset,1):uint()
        local ie_len = buffer(offset+1,2):uint()
        if offset + 3 + ie_len > buffer:len() then break end
        local ie_val = buffer(offset+3, ie_len)

        -- capture top-level IE 0x20 (YBS IP) for use inside nested items
        if ie_type == 0x20 then
            top_ie_0x20 = ie_val
        end

        local item = ies:add(string.format("Item %d", ie_idx))

        -- We will attempt specific parsing for known IE types (and especially handle 0x4A specially).
        -- If nothing matches, we fall back to showing top-level IE fields with friendly name (if known).
        local handled = false

        ------------------------------------------------------------
        -- PDUSessionResourceSetupRequest / common IE parsing
        ------------------------------------------------------------
        if msg_type == 0x06 then -- Setup Request
            if ie_type == 0x20 then -- GlobalNodeID
                handled = true
                item:add("id: id-GlobalNodeID (0x20)")
                item:add("criticality: reject (0)")
                local subval = item:add("value: GlobalNodeID")
                subval:add("PLMN Identity", ie_val(0,3)):append_text(" = " .. tostring(decode_bcd(ie_val(0,3))))
                subval:add("Node ID", ie_val(3, ie_len-3))
            end
        elseif msg_type == 0x07 then -- Setup Response
            if ie_type == 0x30 then
                handled = true
                item:add("id: id-YAMFName (0x30)")
                item:add("criticality: reject (0)")
                item:add("value: YAMF Name = " .. ie_val:string())
            end
        elseif msg_type == 0x08 then -- RadioResourceRequest
            if ie_type == 0x40 then
                handled = true
                item:add("id: id-RadioResourceRequest (0x40)")
                item:add("criticality: reject (0)")
                local rreq = item:add("value: RadioResourceRequest")
                if ie_val:len() < 8 then
                    rreq:add_expert_info(PI_MALFORMED, PI_ERROR, "IE too short for RadioResourceRequest")
                else
                    local ybs_id = ie_val(0,3):uint()
                    local plmn_raw = ie_val(3,3)
                    local tac_val = ie_val(6,2):uint()
                    local plmn_str = decode_plmn(plmn_raw)
                    rreq:add("YBS ID", ie_val(0,3)):append_text(string.format(" = 0x%06X", ybs_id))
                    rreq:add("PLMN Identity", plmn_raw):append_text(" (" .. tostring(plmn_str) .. ")")
                    rreq:add("TAC", ie_val(6,2)):append_text(string.format(" = 0x%04X", tac_val))
                end
            end
        elseif msg_type == 0x09 then -- RadioResourceResponse
            if ie_type == 0x41 then
                handled = true
                local rresp = item:add("value: RadioResourceResponse")
                local yamf_id = ie_val(0,2):uint()
                local bw = ie_val(2,2):uint()
                local freq = ie_val(4,2):uint()
                local power = ie_val(6,2):int()
                rresp:add("YAMF ID", ie_val(0,2)):append_text(" = " .. tostring(yamf_id))
                rresp:add("Bandwidth Allocated (MHz)", ie_val(2,2)):append_text(" = " .. tostring(bw))
                rresp:add("Frequency Allocated (MHz)", ie_val(4,2)):append_text(" = " .. tostring(freq))
                rresp:add("Power (dBm)", ie_val(6,2)):append_text(" = " .. tostring(power))
            end
        elseif msg_type == 0x30 then -- NAS Identity Response
            if ie_type == 0x50 then
                handled = true
                item:set_text("UE Identity (0x50)")
                local val_str = ie_val:string()
                item:add("Value", ie_val):append_text(" = " .. tostring(val_str))
            elseif ie_type == 0x51 then
                handled = true
                item:set_text("UE Security Capabilities (0x51)")
                item:add("Value", ie_val)
            elseif ie_type == 0x52 then
                handled = true
                item:set_text("Requested NSSAI (0x52)")
                item:add("SST", ie_val(0,1))
                item:add("SD", ie_val(1,3))
            elseif ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            end
        elseif msg_type == 0x10 then -- NAS Registration Request (InitialUEMessage style)
            if ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x26 then -- NAS-PDU (common)
                handled = true
                item:add("id: id-NAS-PDU (0x26)")
                item:add("criticality: reject (0)")
                local nas_pdu_node = item:add("value: NAS-PDU")
                nas_pdu_node:add(f_nas_pdu, ie_val)
                local nas_len = ie_val:len()
                local nas_offset = 0
                if nas_len >= 6 then
                    local ext_proto = ie_val(nas_offset, 1):uint()
                    local sec_hdr_type = bit32.rshift(ie_val(nas_offset + 1, 1):uint(), 4)
                    local mac = ie_val(nas_offset + 2, 4)
                    local seq = ie_val(nas_offset + 6, 1):uint()
                    nas_pdu_node:add(string.format("Extended Protocol Discriminator: 0x%02X", ext_proto))
                    nas_pdu_node:add(string.format("Security Header Type: %d", sec_hdr_type))
                    nas_pdu_node:add(string.format("Message Authentication Code: %s", tostring(mac)))
                    nas_pdu_node:add(string.format("Sequence Number: %d", seq))
                else
                    nas_pdu_node:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS-PDU too short")
                end
            elseif ie_type == 0x79 then
                handled = true
                local uli = item:add("value: UserLocationInformation")
                local plmn = ie_val(0,3)
                uli:add("PLMN Identity", plmn):append_text(" = " .. tostring(decode_plmn(plmn)))
                uli:add("NR Cell ID", ie_val(3,5))
                uli:add("TAC", ie_val(8,3)):append_text(string.format(" = %d", ie_val(8,3):uint()))
            end
        elseif msg_type == 0x28 then -- Identity Request
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x26 then
                handled = true
                item:add("id: id-NAS-PDU (0x26)")
                item:add("criticality: reject (0)")
                item:add("value: NAS-PDU = " .. ie_val:bytes():tohex(true))
                if ie_val:len() >= 3 then
                    local nas = item:add("Non-Access-Stratum 5GS (NAS) PDU")
                    local ext_proto_disc = ie_val(0,1):uint()
                    nas:add("Extended protocol discriminator", ie_val(0,1))
                        :append_text(" = 0x" .. string.format("%02X", ext_proto_disc) .. " (5G MM)")
                    local sec_hdr_type = bit32.rshift(ie_val(1,1):uint(), 4)
                    nas:add("Security header type", ie_val(1,1)):append_text(" = " .. tostring(sec_hdr_type))
                    local msg_type = ie_val(2,1):uint()
                    nas:add("Message type", ie_val(2,1)):append_text(" = 0x" .. string.format("%02X", msg_type) .. " (Identity Request)")
                    if ie_val:len() >= 4 then
                        local spare_half_octet = bit32.rshift(ie_val(3,1):uint(),4)
                        local identity_type_val = bit32.band(ie_val(3,1):uint(), 0x07)
                        local identity_type_str = {
                            [0] = "No identity",
                            [1] = "SUCI",
                            [2] = "5G GUTI",
                            [3] = "IMEI",
                            [4] = "IMEISV",
                            [5] = "5G-S-TMSI",
                            [6] = "IMEI and IMEISV",
                            [7] = "Other"
                        }
                        nas:add("Spare Half Octet", ie_val(3,1)):append_text(" = 0x" .. string.format("%X", spare_half_octet))
                        nas:add("5GS identity type", ie_val(3,1))
                            :append_text(" = " .. tostring(identity_type_str[identity_type_val] or ("Unknown ("..tostring(identity_type_val)..")")))
                    end
                else
                    item:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS-PDU IE too short to decode Identity Request fields")
                end
            end
        elseif msg_type == 0x29 then -- DownlinkNASTransport (Authentication Request)
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x26 then
                handled = true
                item:add("id: id-NAS-PDU (0x26)")
                item:add("criticality: reject (0)")
                item:add("value: NAS-PDU = " .. ie_val:bytes():tohex(true))
                local nas = item:add("Non-Access-Stratum 5GS (NAS) PDU")
                if ie_val:len() >= 3 then
                    local epd = ie_val(0,1):uint()
                    local sec_hdr = bit32.rshift(ie_val(1,1):uint(), 4)
                    local msg_type = ie_val(2,1):uint()
                    nas:add("Extended Protocol Discriminator", ie_val(0,1)):append_text(string.format(" = 0x%02X (5G MM)", epd))
                    nas:add("Security Header Type", ie_val(1,1)):append_text(" = " .. tostring(sec_hdr))
                    nas:add("Message Type", ie_val(2,1)):append_text(" = 0x" .. string.format("%02X", msg_type) .. " (Authentication Request)")
                    local offset_n = 3
                    if offset_n < ie_val:len() then
                        local ksi_byte = ie_val(offset_n,1):uint()
                        local tsc = bit32.band(bit32.rshift(ksi_byte, 3), 0x01)
                        local ksi = bit32.band(ksi_byte, 0x07)
                        nas:add("TSC", ie_val(offset_n,1)):append_text(" = " .. tostring(tsc))
                        nas:add("NAS Key Set Identifier", ie_val(offset_n,1)):append_text(" = " .. tostring(ksi))
                        offset_n = offset_n + 1
                    end
                    while offset_n + 2 <= ie_val:len() do
                        local iei = ie_val(offset_n,1):uint()
                        local lenv = ie_val(offset_n+1,1):uint()
                        if offset_n + 2 + lenv > ie_val:len() then
                            nas:add_expert_info(PI_MALFORMED, PI_ERROR, "IE length exceeds NAS-PDU bounds")
                            break
                        end
                        local val = ie_val(offset_n + 2, lenv)
                        if iei == 0x38 then
                            nas:add(f_nas_abba, val)
                        elseif iei == 0x21 then
                            nas:add(f_nas_rand, val)
                        elseif iei == 0x20 then
                            nas:add(f_nas_autn, val)
                        else
                            nas:add(string.format("Unknown IEI 0x%02X", iei), val)
                        end
                        offset_n = offset_n + 2 + lenv
                    end
                else
                    item:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS-PDU too short to decode")
                end
            end
        elseif msg_type == 0x2A then -- UplinkNASTransport (Authentication Response)
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x26 then
                handled = true
                item:add("id: id-NAS-PDU (0x26)")
                item:add("criticality: reject (0)")
                item:add("value: NAS-PDU = " .. ie_val:bytes():tohex(true))
                local nas = item:add("Non-Access-Stratum 5GS (NAS) PDU")
                if ie_val:len() >= 7 then
                    local ext_proto_disc = ie_val(0,1):uint()
                    local sec_hdr_type = bit32.rshift(ie_val(1,1):uint(), 4)
                    local mac = ie_val(2,4)
                    local seq_num = ie_val(6,1):uint()
                    nas:add("Extended Protocol Discriminator", ie_val(0,1)):append_text(" = 0x" .. string.format("%02X", ext_proto_disc))
                    nas:add("Security Header Type", ie_val(1,1)):append_text(" = " .. tostring(sec_hdr_type))
                    nas:add("Message Authentication Code", mac)
                    nas:add("Sequence Number", ie_val(6,1)):append_text(" = " .. tostring(seq_num))
                    local inner_offset = 7
                    if ie_val:len() >= inner_offset + 3 then
                        local inner_epd = ie_val(inner_offset,1):uint()
                        local inner_sec_hdr = bit32.rshift(ie_val(inner_offset + 1,1):uint(), 4)
                        local inner_msg_type = ie_val(inner_offset + 2,1):uint()
                        nas:add("Inner NAS EPD", ie_val(inner_offset,1)):append_text(" = 0x" .. string.format("%02X", inner_epd))
                        nas:add("Inner NAS Security Header Type", ie_val(inner_offset + 1,1)):append_text(" = " .. tostring(inner_sec_hdr))
                        nas:add("NAS Message Type", ie_val(inner_offset + 2,1)):append_text(" = 0x" .. string.format("%02X", inner_msg_type) .. " (Authentication Response)")
                        local off2 = inner_offset + 3
                        while off2 + 2 <= ie_val:len() do
                            local iei = ie_val(off2, 1):uint()
                            local lenv = ie_val(off2 + 1, 1):uint()
                            if off2 + 2 + lenv > ie_val:len() then
                                nas:add_expert_info(PI_MALFORMED, PI_ERROR, "IE length exceeds NAS-PDU bounds")
                                break
                            end
                            local val = ie_val(off2 + 2, lenv)
                            if iei == 0x2D then
                                nas:add("Authentication Response Parameter (RES)", val):append_text(" = " .. val:bytes():tohex(true))
                            else
                                nas:add(string.format("Unknown NAS IEI 0x%02X", iei), val)
                            end
                            off2 = off2 + 2 + lenv
                        end
                    else
                        nas:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS-PDU too short for inner message")
                    end
                else
                    item:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS-PDU too short for header")
                end
            end
        elseif msg_type == 0x11 then -- NAS Security Mode Command
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x60 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (Security Algorithms)")
                item:add(f_ie_len, buffer(offset+1,2))
                local enc_algo = ie_val(0,1):uint()
                local int_algo = ie_val(1,1):uint()
                local imeisv_req = (ie_val(2,1):uint() ~= 0)
                item:add(f_nas_enc_algo, ie_val(0,1)):append_text(string.format(" = 0x%02X", enc_algo))
                item:add(f_nas_int_algo, ie_val(1,1)):append_text(string.format(" = 0x%02X", int_algo))
                item:add(f_nas_imeisv_req, ie_val(2,1)):append_text(" = " .. tostring(imeisv_req))
            elseif ie_type == 0x61 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (NAS Message Container)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_nas_msg_container, ie_val)
            elseif ie_type == 0x62 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (GUTI)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_guti, ie_val)
            end
        elseif msg_type == 0x12 then -- NAS Security Mode Complete
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x70 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (IMEISV)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_imeisv, ie_val)
            elseif ie_type == 0x71 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (EAP Message)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_eap_msg, ie_val)
            elseif ie_type == 0x72 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (Additional Security Capabilities)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_add_sec_caps, ie_val)
            end
        elseif msg_type == 0x13 then -- NAS Registration Accept
            if ie_type == 0x0A then
                handled = true
                item:add("id: id-AMF-UE-NGAP-ID (0x0A)")
                item:add("criticality: reject (0)")
                item:add(f_amf_ue_ngap_id, ie_val)
            elseif ie_type == 0x55 then
                handled = true
                item:add("id: id-gnb-ue-ngap-id (0x55)")
                item:add("criticality: reject (0)")
                item:add(f_gnb_ue_ngap_id, ie_val)
            elseif ie_type == 0x80 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (TAI List)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_tai_list, ie_val)
            elseif ie_type == 0x81 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (GUTI)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_guti, ie_val:bytes():tohex(true))
            elseif ie_type == 0x82 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (DRX Parameters)")
                item:add(f_ie_len, buffer(offset+1,2))
                item:add(f_nas_drx_params, ie_val)
            elseif ie_type == 0x83 then
                handled = true
                item:add(f_ie_type, buffer(offset,1)):append_text(" (Registration Status)")
                item:add(f_ie_len, buffer(offset+1,2))
                local status_val = ie_val:uint()
                local status_str = "Unknown"
                if status_val == 0x00 then status_str = "Registered"
                elseif status_val == 0x01 then status_str = "Registered with restricted services"
                elseif status_val == 0x02 then status_str = "Registration pending"
                elseif status_val == 0x03 then status_str = "Rejected"
                end
                item:add("Status", tostring(status_str))
            end
        end

        ---------------------------------------------------------------------
        -- PDUSessionResourceSetupListSUReq (top-level IE 0x4A) - special handling
        -- This block decodes the nested PDU session entries and Response Transfer
        ---------------------------------------------------------------------
        if msg_type == 0x20 and ie_type == 0x4A then
            handled = true
            item:add("id: id-PDUSessionResourceSetupListSUReq (0x4A)")
            item:add("criticality: reject (0)")
            local list_node = item:add("PDUSessionResourceSetupListSUReq")
            local offset_in = 0

            -- helper: check if a byte likely looks like a NAS TLV IEI we expect
            local function looks_like_nas_tlv(first_byte)
                -- known NAS TLVs used here: DNN(0x25), S-NSSAI(0x22 / 0x02), QoS(0x30), SSC(0x17)
                if first_byte == 0x25 or first_byte == 0x22 or first_byte == 0x02
                   or first_byte == 0x30 or first_byte == 0x17 then
                    return true
                end
                return false
            end

            while offset_in < ie_val:len() do
                if (offset_in + 1) > ie_val:len() then
                    list_node:add_expert_info(PI_MALFORMED, PI_ERROR, "Incomplete PDU Session entry (no session id)")
                    break
                end

                local pdu_session_id = ie_val(offset_in,1):uint()
                local entry_node = list_node:add(string.format("PDU Session Item (ID=%d)", pdu_session_id))
                entry_node:add(f_pdu_session_id, ie_val(offset_in,1))
                offset_in = offset_in + 1

                local remaining = ie_val:len() - offset_in
                if remaining <= 0 then
                    entry_node:add_expert_info(PI_MALFORMED, PI_ERROR, "No response_transfer / NAS present")
                    break
                end

                -- parse NAS header (if present)
                if remaining >= 3 then
                    local nas_offset = offset_in
                    local ext_proto_disc = ie_val(nas_offset,1):uint()
                    local sec_hdr_byte = ie_val(nas_offset+1,1):uint()
                    local security_hdr_type = bit32.rshift(sec_hdr_byte, 4)
                    local nas_msg_type = ie_val(nas_offset+2,1):uint()
                    local nas_hdr = entry_node:add("NAS Header")
                    local sec_str_map = { [0] = "Plain", [1] = "Integrity Protected", [2] = "Integrity+Ciphered" }
                    local sec_str = sec_str_map[security_hdr_type] or "Unknown"
                    nas_hdr:add(f_nas_epd, ie_val(nas_offset,1)):append_text(" (5G-MM)")
                    nas_hdr:add(f_nas_sec_hdr_type, ie_val(nas_offset+1,1))
                           :append_text(" (" .. tostring(sec_str) .. ")")
                    nas_hdr:add(f_nas_msg_type, ie_val(nas_offset+2,1))

                    local tlv_start = nas_offset + 3
                    local tlv_len = ie_val:len() - tlv_start

                    if tlv_len <= 0 then
                        entry_node:add_expert_info(PI_MALFORMED, PI_ERROR, "No NAS TLVs or response transfer present")
                        offset_in = ie_val:len()
                    else
                        -- Decide: TLV list (DNN/etc) vs compact response_transfer.
                        -- Use heuristic: if the first byte at tlv_start looks like a known NAS IEI -> parse TLVs.
                        local first_byte = ie_val(tlv_start,1):uint()
                        if looks_like_nas_tlv(first_byte) then
                            -- Parse NAS TLVs (DNN, S-NSSAI, QoS, SSC)
                            local nas_tlv_offset = tlv_start
                            while nas_tlv_offset + 2 <= ie_val:len() do
                                local iei = ie_val(nas_tlv_offset,1):uint()
                                local lenv = ie_val(nas_tlv_offset+1,1):uint()
                                if nas_tlv_offset + 2 + lenv > ie_val:len() then
                                    entry_node:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS TLV exceeds buffer")
                                    break
                                end
                                local val = ie_val(nas_tlv_offset+2, lenv)
                                if iei == 0x25 then
                                    entry_node:add(f_nas_dnn, val:string())
                                elseif iei == 0x22 or iei == 0x02 then
                                    local s_nssai = entry_node:add("S-NSSAI")
                                    if val:len() >= 1 then
                                        s_nssai:add("sST", val(0,1))
                                        if val:len() > 1 then s_nssai:add("sD", val(1, val:len()-1)) end
                                    else
                                        s_nssai:add_expert_info(PI_MALFORMED, PI_ERROR, "S-NSSAI too short")
                                    end
                                    entry_node:add(f_nas_s_nssai, val)
                                elseif iei == 0x30 then
                                    entry_node:add(f_nas_qos, val)
                                elseif iei == 0x17 then
                                    entry_node:add("SSC Mode", val(0,1)):append_text(" = " .. tostring(val(0,1):uint()))
                                else
                                    entry_node:add(string.format("Unknown NAS IEI 0x%02X", iei), val)
                                end
                                nas_tlv_offset = nas_tlv_offset + 2 + lenv
                            end
                            offset_in = ie_val:len()
                        else
                            -- treat as compact response_transfer (existing behavior), but be defensive:
                            if tlv_len >= 12 then
                                local rt_len_to_read = math.min(19, ie_val:len() - tlv_start)
                                local rt = ie_val(tlv_start, rt_len_to_read)
                                local qos_params = (rt_len_to_read >= 3) and rt(0,3) or nil
                                local gtp_ip_tvb  = (rt_len_to_read >= 7) and rt(3,4) or nil
                                local teid_tvb    = (rt_len_to_read >= 11) and rt(7,4) or nil
                                local qfi_tvb     = (rt_len_to_read >= 12) and rt(11,1) or nil

                                local rt_node = entry_node:add("Response Transfer (compact)")
                                if qos_params then rt_node:add("QOS Parameters"):append_text(" " .. tostring(qos_params:bytes():tohex(true))) end

                                -- Prefer top-level IE 0x20 override for GTP Tunnel IP if present
                                if top_ie_0x20 and top_ie_0x20:len() >= 4 then
                                    local ok_ov, ip_str_ov = pcall(function() return tostring(top_ie_0x20(0,4):ipv4()) end)
                                    if ok_ov then
                                        rt_node:add("GTP Tunnel IP (DL)"):append_text(" " .. tostring(ip_str_ov) .. " (from top-level IE 0x20)")
                                    else
                                        rt_node:add("GTP Tunnel IP (DL)"):append_text(" (invalid top-level IE 0x20)")
                                    end
                                else
                                    if gtp_ip_tvb then
                                        local ok, gtp_ip_str = pcall(function() return tostring(gtp_ip_tvb:ipv4()) end)
                                        if ok then rt_node:add("GTP Tunnel IP (DL)"):append_text(" " .. tostring(gtp_ip_str)) else rt_node:add("GTP Tunnel IP (DL)"):append_text(" (invalid)") end
                                    end
                                end

                                if teid_tvb then rt_node:add(f_teid, teid_tvb):append_text(string.format(" (TEID: 0x%08X)", teid_tvb:uint())) end
                                if qfi_tvb then rt_node:add("QFI"):append_text(" " .. tostring(qfi_tvb:uint())) end

                                -- advance pointer past the compact fields (minimum 12 bytes)
                                offset_in = tlv_start + 12

                                -- parse any remaining TLVs after the compact block (defensive)
                                if offset_in < ie_val:len() then
                                    local nas_tlv_ptr = offset_in
                                    local tlv_trailer_node = rt_node:add("NAS TLVs (trailing)")
                                    while nas_tlv_ptr + 2 <= ie_val:len() do
                                        local iei = ie_val(nas_tlv_ptr,1):uint()
                                        local lenv = ie_val(nas_tlv_ptr+1,1):uint()
                                        if nas_tlv_ptr + 2 + lenv > ie_val:len() then
                                            tlv_trailer_node:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS TLV exceeds session bounds")
                                            break
                                        end
                                        local val = ie_val(nas_tlv_ptr + 2, lenv)
                                        if iei == 0x25 then
                                            tlv_trailer_node:add(f_nas_dnn, val):append_text(" = " .. tostring(val:string()))
                                        elseif iei == 0x17 then
                                            tlv_trailer_node:add("SSC Mode", val(0,1)):append_text(" = " .. tostring(val(0,1):uint()))
                                        elseif iei == 0x22 or iei == 0x02 then
                                            local s_nssai = tlv_trailer_node:add("S-NSSAI")
                                            if val:len() >= 1 then
                                                s_nssai:add("sST", val(0,1))
                                                if val:len() > 1 then s_nssai:add("sD", val(1, val:len()-1)) end
                                            else
                                                s_nssai:add_expert_info(PI_MALFORMED, PI_ERROR, "S-NSSAI too short")
                                            end
                                        elseif iei == 0x30 then
                                            tlv_trailer_node:add(f_nas_qos, val)
                                        else
                                            tlv_trailer_node:add(string.format("Unknown NAS IEI 0x%02X", iei), val)
                                        end
                                        nas_tlv_ptr = nas_tlv_ptr + 2 + lenv
                                    end
                                    offset_in = ie_val:len()
                                end
                            else
                                entry_node:add_expert_info(PI_MALFORMED, PI_ERROR, "Not enough bytes for compact response_transfer")
                                offset_in = ie_val:len()
                            end
                        end
                    end
                else
                    entry_node:add_expert_info(PI_MALFORMED, PI_ERROR, "NAS header too short")
                    break
                end
            end
        end


        ---------------------------------------------------------------------
        -- PDUSessionResourceSetupResponse (0x21) decoding kept intact below...
        -- (unchanged from your original, still present in file)
        ---------------------------------------------------------------------
        if not handled and msg_type == 0x21 and ie_type == 0x4B then
            handled = true
            item:add("id: id-PDUSessionResourceSetupListSURes (0x4B)")
            item:add("criticality: ignore (1)")
            local value_node = item:add("value: PDUSessionResourceSetupListSURes")
            local list_offset = 0
            local list_len = ie_val:len()
            while list_offset < list_len do
                local item_node = value_node:add("PDUSessionResourceSetupItemSURes")
                local pdu_session_id = ie_val(list_offset,1):uint()
                item_node:add(f_pdu_session_id, ie_val(list_offset,1)):append_text(string.format(" = %d", pdu_session_id))
                list_offset = list_offset + 1
                local response_transfer_len = list_len - list_offset
                local response_transfer = ie_val(list_offset, response_transfer_len)
                local transfer_node = item_node:add("pDUSessionResourceSetupResponseTransfer")
                local rt_offset = 0
                local dlqos_node = transfer_node:add("dLQosFlowPerTNLInformation")
                local up_transport_node = dlqos_node:add("uPTransportLayerInformation: gTPTunnel")
                -- transportLayerAddress (IPv4)
                if response_transfer:len() >= rt_offset + 4 then
                    if top_ie_0x20 and top_ie_0x20:len() >= 4 then
                        local ip_field = top_ie_0x20(0,4)
                        local ok_ov, ip_str_ov = pcall(function() return tostring(ip_field:ipv4()) end)
                        if ok_ov then up_transport_node:add(f_gtp_ip, ip_field):append_text(" = " .. tostring(ip_str_ov) .. " (from top-level IE 0x20)") else up_transport_node:add(f_gtp_ip, top_ie_0x20(0,4)):append_text(" = (invalid top-level IE 0x20)") end
                    else
                        local ip_field = response_transfer(rt_offset, 4)
                        local ok, ip_str = pcall(function() return tostring(ip_field:ipv4()) end)
                        if ok then up_transport_node:add(f_gtp_ip, ip_field):append_text(" = " .. tostring(ip_str)) else up_transport_node:add(f_gtp_ip, ip_field):append_text(" = (invalid)") end
                        rt_offset = rt_offset + 4
                    end
                end
                if response_transfer:len() >= rt_offset + 4 then
                    local teid_bytes = {
                        response_transfer(rt_offset,1):uint(),
                        response_transfer(rt_offset+1,1):uint(),
                        response_transfer(rt_offset+2,1):uint(),
                        response_transfer(rt_offset+3,1):uint()
                    }
                    local teid = teid_bytes[1] * 2^24 + teid_bytes[2] * 2^16 + teid_bytes[3] * 2^8 + teid_bytes[4]
                    up_transport_node:add(f_gtp_teid, response_transfer(rt_offset, 4)):append_text(string.format(" = 0x%08X", teid))
                    rt_offset = rt_offset + 4
                end
                if response_transfer:len() >= rt_offset + 2 then rt_offset = rt_offset + 2 end
                if response_transfer:len() >= rt_offset + 1 then
                    local qos_flow_id = response_transfer(rt_offset, 1):uint()
                    local qos_flow_list_node = dlqos_node:add("associatedQosFlowList")
                    qos_flow_list_node:add(f_qos_flow_id, response_transfer(rt_offset, 1)):append_text(string.format(" = %d", qos_flow_id))
                    rt_offset = rt_offset + 1
                end
                if response_transfer:len() >= rt_offset + 4 then
                    local ue_ip_field = response_transfer(rt_offset, 4)
                    local ok2, ue_ip_str = pcall(function() return tostring(ue_ip_field:ipv4()) end)
                    if ok2 then transfer_node:add(f_ue_ip, ue_ip_field):append_text(" = " .. tostring(ue_ip_str)) else transfer_node:add(f_ue_ip, ue_ip_field):append_text(" = (invalid)") end
                    rt_offset = rt_offset + 4
                else
                    transfer_node:add_expert_info(PI_MALFORMED, PI_ERROR, "UE IP field is missing or out of bounds")
                end
                list_offset = list_len
            end
        end

        ---------------------------------------------------------------------
        -- FALLBACK: if nobody handled the IE, add generic top-level IE fields
        -- but show friendly name where known. This prevents duplicate printing.
        ---------------------------------------------------------------------
        if not handled then
            local friendly = TOP_IE_NAMES[ie_type]
            if friendly then
                item:add(f_ie_type, buffer(offset,1)):append_text(" (" .. tostring(friendly) .. ")")
            else
                item:add(f_ie_type, buffer(offset,1))
            end
            item:add(f_ie_len, buffer(offset+1,2))
            item:add(f_ie_value, ie_val)
        end

        -- advance to next top-level IE
        offset = offset + 3 + ie_len
        ie_idx = ie_idx + 1
    end
end

-- Register dissector on UDP port 7070 (used in your captures)
local udp_port = DissectorTable.get("udp.port")
udp_port:add(7070, yacp_proto)
