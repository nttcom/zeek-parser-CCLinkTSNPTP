spicy_add_analyzer(
    NAME cc_link_tsn_ptp
    PACKAGE_NAME zeek-parser-CCLinkTSNPTP
    SOURCES cc_link_tsn_ptp.spicy cc_link_tsn_ptp.evt zeek_cc_link_tsn_ptp.spicy
    SCRIPTS __load__.zeek main.zeek dpd.sig
)
