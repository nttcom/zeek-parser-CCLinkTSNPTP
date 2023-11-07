# Zeek-Parser-CCLinkTSNPTP

## Overview

Zeek-Parser-CCLinkTSNPTP is a Zeek plug-in that can analyze time synchronization frame in CC-Link IE TSN of the [CC-Link family](https://www.cc-link.org/ja/cclink/index.html).

## Installation

### Manual Installation

Before using this plug-in, please make sure Zeek, Spicy has been installed.

````
# Check Zeek
~$ zeek -version
zeek version 5.0.0

# Check Spicy
~$ spicyz -version
1.3.16
~$ spicyc -version
spicyc v1.5.0 (d0bc6053)

# The path of zeek in this manual is based on the following output
~$ which zeek
/usr/local/zeek/bin/zeek
````

Use `git clone` to get a copy of this repository to your local environment.
```
~$ git clone https://github.com/nttcom/zeek-parser-CCLinkTSNPTP.git
```

## Usage

### For manual installation

Compile source code and copy the object files to the following path.
```
~$ cd ~/zeek-parser-CCLinkTSNPTP/analyzer
~$ spicyz -o cc_link_tsn_ptp.hlto cc_link_tsn_ptp.spicy cc_link_tsn_ptp.evt
# cc_link_tsn_ptp.hlto is generated
~$ cp cc_link_tsn_ptp.hlto /usr/local/zeek/lib/zeek-spicy/modules/
```

Then, copy the zeek file to the following paths.
```
~$ cd ~/zeek-parser-CCLinkTSNPTP/scripts/
~$ cp main.zeek /usr/local/zeek/share/zeek/site/cc_link_tsn_ptp.zeek
```

Finally, import the Zeek plugin.
```
~$ tail /usr/local/zeek/share/zeek/site/local.zeek
... Omit ...
@load cc_link_tsn_ptp
```

This plug-in generates a `cclink-ie-tsn-ptp.log` by the command below:
```
~$ cd ~/zeek-parser-CCLinkTSNPTP/testing/Traces
~$ zeek -Cr test.pcap /usr/local/zeek/share/zeek/site/cc_link_tsn_ptp.zeek
```

## Log type and description

This plug-in monitors all functions of time synchronization frame in CC-Link IE TSN and outputs them as `cclink-ie-tsn-ptp.log`.

| Field | Type | Description |
| --- | --- | --- |
| ts | time | timestamp of the first communication |
| src_mac | string | source MAC address |
| dst_mac | string | destination MAC address |
| protocol | string | protocol name |
| pdu_type | string | PDU type |
| pdu_choice | string | name of PDU service choice |
| number | int | number of packet occurrence |
| ts_end | time | Timestamp of the last communication |

An example of `cclink-ie-tsn-ptp.log` is as follows:
```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	cclink-ie-tsn-ptp
#open	2023-10-19-04-39-09
#fields	ts	src_mac	dst_mac	protocol	pdu_type	pdu_choice	number	ts_end
#types	time	string	string	string	string	string	int	time
1697689393.379735	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpSync	30	1697689393.382119
1697689491.686702	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayReq	30	1697689491.689062
1697689574.280246	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayResp	30	1697689574.282636
1697689647.373331	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpFollowUp	30	1697689647.375735
1697689755.561404	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayRespFollowUp	30	1697689755.563747
1697689840.681484	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpAnnounce	30	1697689840.683890
1697689912.815431	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpdelayReq	30	1697689912.817823
1697690093.693609	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpdelayResp	30	1697690093.696056
#close	2023-10-19-04-39-09
```

## Related Software

This plug-in is used by [OsecT](https://github.com/nttcom/OsecT).
