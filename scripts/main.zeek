module PacketAnalyzer::SPICY_RAWLAYER;
module TSN_PTP;

export {
	redef enum Log::ID += { LOG };

	type Info: record {
		ts:				time &log &optional;
		src_mac:		string &log &optional;
		dst_mac:		string &log &optional;
		protocol:		string &log &optional;
		pdu_type: 		string &log &optional;
		pdu_choice:     string &log &optional;
		number:			int &log &optional;
		ts_end:			time &log &optional;
	};

	type AggregationData: record {
		src_mac:		string &log &optional;
		dst_mac:		string &log &optional;
		protocol:		string &log &optional;
		pdu_type: 		string &log &optional;
		pdu_choice:     string &log &optional;
	};

	type Ts_num: record {
		ts_s:			time &log;
		num: 			int &log;
		ts_e: 			time &log &optional;
	};

	function insert_log(res_aggregationData: table[AggregationData] of Ts_num, idx: AggregationData): interval
	{
	local info_insert: Info = [];
	info_insert$ts = res_aggregationData[idx]$ts_s;
	info_insert$src_mac = idx$src_mac;
	info_insert$dst_mac = idx$dst_mac;
	info_insert$protocol = idx$protocol;
	info_insert$pdu_type = idx$pdu_type;
	info_insert$pdu_choice = idx$pdu_choice;
	if ( res_aggregationData[idx]?$ts_e ){
		info_insert$ts_end = res_aggregationData[idx]$ts_e;
	}
	if ( res_aggregationData[idx]?$num ){
		info_insert$number = res_aggregationData[idx]$num;
	}
	Log::write(TSN_PTP::LOG, info_insert);

	return 0secs;
	}

	global res_aggregationData: table[AggregationData] of Ts_num &create_expire=60sec &expire_func=insert_log;
}

event zeek_init() &priority=5
	{
	Log::create_stream(TSN_PTP::LOG, [$columns = Info, $path="cclink-ie-tsn-ptp"]);
	}

event zeek_init()
	{
	if ( ! PacketAnalyzer::try_register_packet_analyzer_by_name("Ethernet", 0x88f7, "spicy::TSN_PTP") )
		print "cannot register raw layer analyzer";
	}

function create_aggregationData(info: Info): AggregationData
	{
	local aggregationData: AggregationData;
	aggregationData$src_mac = info$src_mac;
	aggregationData$dst_mac = info$dst_mac;
	aggregationData$protocol = info$protocol;
	aggregationData$pdu_type = info$pdu_type;
	aggregationData$pdu_choice = info$pdu_choice;

	return aggregationData;
	}

function insert_res_aggregationData(aggregationData: AggregationData, info: Info): string
	{
		if (aggregationData in res_aggregationData){
			res_aggregationData[aggregationData]$num = res_aggregationData[aggregationData]$num + 1;
			res_aggregationData[aggregationData]$ts_e = info$ts;
		} else {
			res_aggregationData[aggregationData] = [$ts_s = info$ts, $num = 1, $ts_e = info$ts];
		}

		return "done";
	}


event raw::ptpSync(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpSync";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpPdelayReq(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpPdelayReq";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpPdelayResp(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpPdelayResp";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpFollowUp(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpFollowUp";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpPdelayRespFollowUp(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpPdelayRespFollowUp";

	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpAnnounce(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpAnnounce";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpdelayReq(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpdelayReq";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


event raw::ptpdelayResp(p: raw_pkt_hdr)
	{
	local info: Info;
	local aggregationData: AggregationData;
	info$ts = network_time();
	info$src_mac = p$l2$src;
	info$dst_mac = p$l2$dst;
	info$protocol = "cclink_ie_tsn";
	info$pdu_type = "ptp";
	info$pdu_choice = "ptpdelayResp";
		
	aggregationData = create_aggregationData(info);
	insert_res_aggregationData(aggregationData, info);
	}


#local debug
event zeek_done()
{
	for ( i in res_aggregationData )
	{
		local info: Info = [];
		info$ts = res_aggregationData[i]$ts_s;
		info$src_mac = i$src_mac;
		info$dst_mac = i$dst_mac;
		info$protocol = i$protocol;
		info$pdu_type = i$pdu_type;
		info$pdu_choice = i$pdu_choice;
		if ( res_aggregationData[i]?$ts_e ){
			info$ts_end = res_aggregationData[i]$ts_e;
		}
		if ( res_aggregationData[i]?$num ){
			info$number = res_aggregationData[i]$num;
		}

		Log::write(TSN_PTP::LOG, info);
	}
}