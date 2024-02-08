# Zeek-Parser-CCLinkTSNPTP

English is [here](https://github.com/nttcom/zeek-parser-CCLinkTSNPTP/blob/main/README_en.md)

## 概要

Zeek-Parser-CCLinkTSNPTPとは[CC-Linkファミリー](https://www.cc-link.org/ja/cclink/index.html)のCC-Link IE TSNの時刻同期フレームを解析できるZeekプラグインです。

## インストール

### パッケージマネージャーによるインストール

このプラグインは[Zeek Package Manger](https://docs.zeek.org/projects/package-manager/en/stable/index.html)用のパッケージとして提供されています。

以下のコマンドを実行することで、本プラグインは利用可能になります。
```
zkg refresh
zkg install zeek-parser-CCLinkTSNPTP
```

### マニュアルインストール

本プラグインを利用する前に、Zeek, Spicyがインストールされていることを確認します。

```
# Zeekのチェック
~$ zeek -version
zeek version 5.0.0

# Spicyのチェック
~$ spicyz -version
1.3.16
~$ spicyc -version
spicyc v1.5.0 (d0bc6053)

# 本マニュアルではZeekのパスが以下であることを前提としています。
~$ which zeek
/usr/local/zeek/bin/zeek
```

本リポジトリをローカル環境に `git clone` します。

```
~$ git clone https://github.com/nttcom/zeek-parser-CCLinkTSNPTP.git
```

## 使い方

### マニュアルインストールの場合

ソースコードをコンパイルして、オブジェクトファイルを以下のパスにコピーします。

```
~$ cd ~/zeek-parser-CCLinkTSNPTP/analyzer
~$ spicyz -o cc_link_tsn_ptp.hlto cc_link_tsn_ptp.spicy cc_link_tsn_ptp.evt
# cc_link_tsn_ptp.hltoが生成されます
~$ cp cc_link_tsn_ptp.hlto /usr/local/zeek/lib/zeek-spicy/modules/
```

同様にZeekファイルを以下のパスにコピーします。

```
~$ cd ~/zeek-parser-CCLinkTSNPTP/scripts/
~$ cp main.zeek /usr/local/zeek/share/zeek/site/cc_link_tsn_ptp.zeek
```

最後にZeekプラグインをインポートします。

```
~$ tail /usr/local/zeek/share/zeek/site/local.zeek
...省略...
@load cc_link_tsn_ptp
```

本プラグインを使うことで `cclink-ie-tsn-ptp.log` が生成されます。

```
~$ cd ~/zeek-parser-CCLinkTSNPTP/testing/Traces
~$ zeek -Cr test.pcap /usr/local/zeek/share/zeek/site/cc_link_tsn_ptp.zeek
```

## ログのタイプと説明

本プラグインはCC-Link IE TSNの時刻同期フレームの全ての関数を監視して`cclink-ie-tsn-ptp.log`として出力します。

| フィールド | タイプ | 説明 |
| --- | --- | --- |
| ts | time | 最初に通信した時のタイムスタンプ |
| src_mac | string | 送信元MACアドレス |
| dst_mac | string | 宛先MACアドレス |
| service | string | プロトコル名 |
| flame_type | string | データフレームの名前 |
| pdu_type | string | プロトコルの関数名 |
| number | int | パケット出現回数 |
| ts_end | time | 最後に通信した時のタイムスタンプ |

`cclink-ie-tsn-ptp.log` の例は以下のとおりです。

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	cclink-ie-tsn-ptp
#open	2023-11-08-23-24-49
#fields	ts	src_mac	dst_mac	service	flame_type	pdu_type	number	ts_end
#types	time	string	string	string	string	string	int	time
1697689393.379735	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpSync	30	1697689393.382119
1697689491.686702	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayReq	30	1697689491.689062
1697689574.280246	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayResp	30	1697689574.282636
1697689647.373331	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpFollowUp	30	1697689647.375735
1697689755.561404	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpPdelayRespFollowUp	30	1697689755.563747
1697689840.681484	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpAnnounce	30	1697689840.683890
1697689912.815431	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpdelayReq	30	1697689912.817823
1697690093.693609	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	ptp	ptpdelayResp	30	1697690093.696056
#close	2023-11-08-23-24-49
```

## 関連ソフトウェア

本プラグインは[OsecT](https://github.com/nttcom/OsecT)で利用されています。
