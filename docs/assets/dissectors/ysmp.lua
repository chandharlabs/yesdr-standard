-- YSMPProtocol Dissector (Updated with YSMReport support)
ysmp_proto = Proto("YSMP", "YSMP Setup Protocol")

-- Header Fields
local f_version = ProtoField.uint8("ysmp.version", "Version", base.DEC)
local f_msgtype = ProtoField.uint8("ysmp.msgtype", "Message Type", base.HEX)
local f_length  = ProtoField.uint16("ysmp.length", "Payload Length", base.DEC)

-- Information Elements
local f_ysmID           = ProtoField.uint32("ysmp.ysmID", "YSM ID", base.DEC)
local f_loc             = ProtoField.string("ysmp.location", "Location")
local f_caps            = ProtoField.uint8("ysmp.capabilities", "Capabilities", base.HEX)
local f_band            = ProtoField.uint16("ysmp.band", "Scan Band (MHz)", base.DEC)
local f_fft             = ProtoField.uint16("ysmp.fft", "FFT Size", base.DEC)
local f_power           = ProtoField.int16("ysmp.power", "Max Power (dBm)", base.DEC)
local f_status          = ProtoField.uint8("ysmp.status", "Status Code", base.DEC)
local f_respmsg         = ProtoField.string("ysmp.response_msg", "Response Message")
local f_assigned_freq   = ProtoField.uint16("ysmp.assigned_freq", "Assigned Frequency (MHz)", base.DEC)
local f_assigned_bw     = ProtoField.uint16("ysmp.assigned_bw", "Assigned Bandwidth (MHz)", base.DEC)
local f_allocated_power = ProtoField.int8("ysmp.allocated_power", "Allocated Power (dBm)", base.DEC)

-- Radio Resource IE fields
local f_ie20_raw       = ProtoField.bytes("ysmp.ie20.raw", "Radio Resource Raw Data")
local f_ie20_res_type  = ProtoField.uint8("ysmp.ie20.res_type", "Resource Type", base.DEC)
local f_ie20_res_val1  = ProtoField.uint8("ysmp.ie20.res_val1", "Frequency", base.DEC)
local f_ie20_res_val2  = ProtoField.uint8("ysmp.ie20.res_val2", "Band", base.DEC)
local f_ie20_res_val3  = ProtoField.uint8("ysmp.ie20.res_val3", "Power", base.DEC)

-- YSMReport Fields
local f_timestamp        = ProtoField.string("ysmp.report.timestamp", "Timestamp")
local f_start_freq       = ProtoField.uint32("ysmp.report.start_freq", "Start Frequency (MHz)", base.DEC)
local f_end_freq         = ProtoField.uint32("ysmp.report.end_freq", "End Frequency (MHz)", base.DEC)
local f_occupancy        = ProtoField.uint8("ysmp.report.occupancy", "Occupancy (%)", base.DEC)
local f_num_measurements = ProtoField.uint16("ysmp.report.num_measurements", "Number of Measurements", base.DEC)
local f_decision         = ProtoField.string("ysmp.report.decision", "Decision")

ysmp_proto.fields = {
    f_version, f_msgtype, f_length,
    f_ysmID, f_loc, f_caps, f_band, f_fft, f_power,
    f_status, f_respmsg, f_assigned_freq, f_assigned_bw,
    f_allocated_power,
    f_ie20_raw, f_ie20_res_type, f_ie20_res_val1, f_ie20_res_val2, f_ie20_res_val3,
    f_timestamp, f_start_freq, f_end_freq, f_occupancy, f_num_measurements, f_decision
}

function ysmp_proto.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = "YSMP"
    local total_len = buffer:len()
    if total_len < 4 then return end

    local msgtype_val = buffer(1,1):uint()
    local msgtype_str = ({
        [0x10] = "YSMSetupRequest",
        [0x11] = "YSMSetupResponse",
        [0x31] = "YSMReport"
    })[msgtype_val] or string.format("Unknown (0x%02X)", msgtype_val)

    pinfo.cols.info = msgtype_str

    -- First pass to gather scan bands (for validation)
    local scan_band_ranges = {}
    local offset = 4
    while offset + 3 <= total_len do
        local ie_type = buffer(offset,1):uint()
        local ie_len  = buffer(offset+1,2):uint()
        if ie_len == 0 or (offset + 3 + ie_len) > total_len then break end
        if ie_type == 0x04 then
            for i=0, ie_len-1, 2 do
                if (i+2) <= ie_len then
                    table.insert(scan_band_ranges, buffer(offset+3+i, 2):uint())
                end
            end
        end
        offset = offset + 3 + ie_len
    end

    -- Begin decoding
    local subtree = tree:add(ysmp_proto, buffer(), "YSMPProtocol (" .. msgtype_str .. ")")
    subtree:add(f_version, buffer(0,1))
    subtree:add(f_msgtype, buffer(1,1))
    subtree:add(f_length,  buffer(2,2))

    offset = 4
    while offset + 3 <= total_len do
        local ie_type = buffer(offset,1):uint()
        local ie_len  = buffer(offset+1,2):uint()
        if ie_len == 0 or (offset + 3 + ie_len) > total_len then
            subtree:add_expert_info(PI_MALFORMED, PI_ERROR, "Malformed IE length or buffer overflow")
            break
        end

        local ie_val  = buffer(offset+3, ie_len)
        local ie_tree = subtree:add(buffer(offset, 3+ie_len), string.format("IE 0x%02X", ie_type))

        if ie_type == 0x01 then
            ie_tree:add(f_ysmID, ie_val)
        elseif ie_type == 0x02 then
            ie_tree:add(f_loc, ie_val:string())
        elseif ie_type == 0x03 then
            ie_tree:add(f_caps, ie_val)
        elseif ie_type == 0x04 then
            for i=0, ie_len-1, 2 do
                if (i+2) <= ie_len then
                    local band = ie_val(i,2)
                    ie_tree:add(f_band, band):append_text(" MHz")
                end
            end
        elseif ie_type == 0x05 then
            ie_tree:add(f_fft, ie_val)
        elseif ie_type == 0x06 then
            ie_tree:add(f_power, ie_val):append_text(" dBm")
        elseif ie_type == 0x11 then
            local val = ie_val(0,1):uint()
            local meaning = (val == 0) and "Success" or "Failure"
            ie_tree:add(f_status, ie_val(0,1)):append_text(" (" .. meaning .. ")")
        elseif ie_type == 0x12 then
            ie_tree:add(f_respmsg, ie_val:string())
        elseif ie_type == 0x13 then
            local assigned_freq = ie_val(0,2):uint()
            ie_tree:add(f_assigned_freq, ie_val(0,2)):append_text(" MHz")
            local valid = false
            for _, band in ipairs(scan_band_ranges) do
                if assigned_freq == band then valid = true break end
            end
            if not valid then
                ie_tree:add_expert_info(PI_WARN, PI_REASSEMBLE, "Assigned frequency not in scanned bands")
            end
        elseif ie_type == 0x14 then
            ie_tree:add(f_assigned_bw, ie_val(0,2)):append_text(" MHz")
        elseif ie_type == 0x15 then
            ie_tree:add(f_allocated_power, ie_val(0,1)):append_text(" dBm")
        elseif ie_type == 0x20 then
            ie_tree:add(f_ie20_raw, ie_val)
            if ie_len == 4 then
                ie_tree:add(f_ie20_res_type, ie_val(0,1))
                ie_tree:add(f_ie20_res_val1, ie_val(1,1))
                ie_tree:add(f_ie20_res_val2, ie_val(2,1))
                ie_tree:add(f_ie20_res_val3, ie_val(3,1))
            else
                ie_tree:add_expert_info(PI_MALFORMED, PI_WARN, "Radio Resource IE expected 4 bytes")
            end
        -- YSMReport specific IEs
        elseif ie_type == 0x40 then  -- Timestamp (string)
            ie_tree:add(f_timestamp, ie_val:string())
        elseif ie_type == 0x41 then  -- Start Frequency (4 bytes)
            ie_tree:add(f_start_freq, ie_val(0,4))
        elseif ie_type == 0x42 then  -- End Frequency (4 bytes)
            ie_tree:add(f_end_freq, ie_val(0,4))
        elseif ie_type == 0x43 then  -- Occupancy (1 byte)
            ie_tree:add(f_occupancy, ie_val(0,1))
        elseif ie_type == 0x44 then  -- Num Measurements (2 bytes)
            ie_tree:add(f_num_measurements, ie_val(0,2))
        elseif ie_type == 0x45 then  -- Decision (string)
            ie_tree:add(f_decision, ie_val:string())
        else
            ie_tree:add(buffer(offset+3, ie_len), "Unknown IE")
            ie_tree:add_expert_info(PI_UNDECODED, PI_NOTE, "Unknown IE type")
        end

        offset = offset + 3 + ie_len
    end
end

-- Register dissector for UDP port 9090
local udp_table = DissectorTable.get("udp.port")
udp_table:add(9090, ysmp_proto)

