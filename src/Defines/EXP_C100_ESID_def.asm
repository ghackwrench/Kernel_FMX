ESID_EXP_CARD_INFO      = $AE0000    ; Read Only (32 Bytes Card ID - READ ONLY)
ESID_ID_NAME_ASCII      = $AE0000    ; 15 Characters + $00
ESID_ID_VENDOR_ID_Lo    = $AE0010    ; Foenix Project Reserved ID: $F0E1
ESID_ID_VENDOR_ID_Hi    = $AE0011
ESID_ID_CARD_ID_Lo      = $AE0012    ; $9172 - C100-ESID 
ESID_ID_CARD_ID_Hi      = $AE0013
ESID_ID_CARD_CLASS_Lo   = $AE0014    ; TBD
ESID_ID_CARD_CLASS_Hi   = $AE0015    ; TBD
ESID_ID_CARD_SUBCLSS_Lo = $AE0016    ; TBD
ESID_ID_CARD_SUBCLSS_Hi = $AE0017    ; TBD
ESID_ID_CARD_UNDEFINED0 = $AE0018    ; TBD
ESID_ID_CARD_UNDEFINED1 = $AE0019    ; TBD
ESID_ID_CARD_HW_Rev     = $AE001A    ; 00 - in Hex
ESID_ID_CARD_FPGA_Rev   = $AE001B    ; 00 - in Hex
ESID_ID_CARD_UNDEFINED2 = $AE001C    ; TBD
ESID_ID_CARD_UNDEFINED3 = $AE001D    ; TBD
ESID_ID_CARD_CHKSUM0    = $AE001E    ; Not Supported Yet
ESID_ID_CARD_CHKSUM1    = $AE001F    ; Not Supported Yet
; ESIDANSION CARD ESID-C100-ESID
ESID_SIDL_V1_FREQ_LO    = $AED000 ;SID - L - Voice 1 (Write Only) - FREQ LOW
ESID_SIDL_V1_FREQ_HI    = $AED001 ;SID - L - Voice 1 (Write Only) - FREQ HI
ESID_SIDL_V1_PW_LO      = $AED002 ;SID - L - Voice 1 (Write Only) - PW LOW
ESID_SIDL_V1_PW_HI      = $AED003 ;SID - L - Voice 1 (Write Only) - PW HI
ESID_SIDL_V1_CTRL       = $AED004 ;SID - L - Voice 1 (Write Only) - CTRL REG
ESID_SIDL_V1_ATCK_DECY  = $AED005 ;SID - L - Voice 1 (Write Only) - ATTACK / DECAY
ESID_SIDL_V1_SSTN_RLSE  = $AED006 ;SID - L - Voice 1 (Write Only) - SUSTAIN / RELEASE
ESID_SIDL_V2_FREQ_LO    = $AED007 ;SID - L - Voice 2 (Write Only) - FREQ LOW
ESID_SIDL_V2_FREQ_HI    = $AED008 ;SID - L - Voice 2 (Write Only) - FREQ HI
ESID_SIDL_V2_PW_LO      = $AED009 ;SID - L - Voice 2 (Write Only) - PW LOW
ESID_SIDL_V2_PW_HI      = $AED00A ;SID - L - Voice 2 (Write Only) - PW HI
ESID_SIDL_V2_CTRL       = $AED00B ;SID - L - Voice 2 (Write Only) - CTRL REG
ESID_SIDL_V2_ATCK_DECY  = $AED00C ;SID - L - Voice 2 (Write Only) - ATTACK / DECAY
ESID_SIDL_V2_SSTN_RLSE  = $AED00D ;SID - L - Voice 2 (Write Only) - SUSTAIN / RELEASE
ESID_SIDL_V3_FREQ_LO    = $AED00E ;SID - L - Voice 3 (Write Only) - FREQ LOW
ESID_SIDL_V3_FREQ_HI    = $AED00F ;SID - L - Voice 3 (Write Only) - FREQ HI
ESID_SIDL_V3_PW_LO      = $AED010 ;SID - L - Voice 3 (Write Only) - PW LOW
ESID_SIDL_V3_PW_HI      = $AED011 ;SID - L - Voice 3 (Write Only) - PW HI
ESID_SIDL_V3_CTRL       = $AED012 ;SID - L - Voice 3 (Write Only) - CTRL REG
ESID_SIDL_V3_ATCK_DECY  = $AED013 ;SID - L - Voice 3 (Write Only) - ATTACK / DECAY
ESID_SIDL_V3_SSTN_RLSE  = $AED014 ;SID - L - Voice 3 (Write Only) - SUSTAIN / RELEASE
ESID_SIDL_FC_LO         = $AED015 ;SID - L - Filter (Write Only) - FC LOW
ESID_SIDL_FC_HI         = $AED016 ;SID - L - Filter (Write Only) - FC HI
ESID_SIDL_RES_FILT      = $AED017 ;SID - L - Filter (Write Only) - RES / FILT
ESID_SIDL_MODE_VOL      = $AED018 ;SID - L - Filter (Write Only) - MODE / VOL
ESID_SIDL_POT_X         = $AED019 ;SID - L - Misc (Read Only) - POT X (C256 - NOT USED)
ESID_SIDL_POT_Y         = $AED01A ;SID - L - Misc (Read Only) - POT Y (C256 - NOT USED)
ESID_SIDL_OSC3_RND      = $AED01B ;SID - L - Misc (Read Only) - OSC3 / RANDOM
ESID_SIDL_ENV3          = $AED01C ;SID - L - Misc (Read Only)  - ENV3
ESID_SIDL_NOT_USED0     = $AED01D ;SID - L - NOT USED
ESID_SIDL_NOT_USED1     = $AED01E ;SID - L - NOT USED
ESID_SIDL_NOT_USED2     = $AED01F ;SID - L - NOT USED

; ESIDANSION CARD ESID-C100-ESID
ESID_SIDR_V1_FREQ_LO    = $AED100 ;SID - L - Voice 1 (Write Only) - FREQ LOW
ESID_SIDR_V1_FREQ_HI    = $AED101 ;SID - L - Voice 1 (Write Only) - FREQ HI
ESID_SIDR_V1_PW_LO      = $AED102 ;SID - L - Voice 1 (Write Only) - PW LOW
ESID_SIDR_V1_PW_HI      = $AED103 ;SID - L - Voice 1 (Write Only) - PW HI
ESID_SIDR_V1_CTRL       = $AED104 ;SID - L - Voice 1 (Write Only) - CTRL REG
ESID_SIDR_V1_ATCK_DECY  = $AED105 ;SID - L - Voice 1 (Write Only) - ATTACK / DECAY
ESID_SIDR_V1_SSTN_RLSE  = $AED106 ;SID - L - Voice 1 (Write Only) - SUSTAIN / RELEASE
ESID_SIDR_V2_FREQ_LO    = $AED107 ;SID - L - Voice 2 (Write Only) - FREQ LOW
ESID_SIDR_V2_FREQ_HI    = $AED108 ;SID - L - Voice 2 (Write Only) - FREQ HI
ESID_SIDR_V2_PW_LO      = $AED109 ;SID - L - Voice 2 (Write Only) - PW LOW
ESID_SIDR_V2_PW_HI      = $AED10A ;SID - L - Voice 2 (Write Only) - PW HI
ESID_SIDR_V2_CTRL       = $AED10B ;SID - L - Voice 2 (Write Only) - CTRL REG
ESID_SIDR_V2_ATCK_DECY  = $AED10C ;SID - L - Voice 2 (Write Only) - ATTACK / DECAY
ESID_SIDR_V2_SSTN_RLSE  = $AED10D ;SID - L - Voice 2 (Write Only) - SUSTAIN / RELEASE
ESID_SIDR_V3_FREQ_LO    = $AED10E ;SID - L - Voice 3 (Write Only) - FREQ LOW
ESID_SIDR_V3_FREQ_HI    = $AED10F ;SID - L - Voice 3 (Write Only) - FREQ HI
ESID_SIDR_V3_PW_LO      = $AED110 ;SID - L - Voice 3 (Write Only) - PW LOW
ESID_SIDR_V3_PW_HI      = $AED111 ;SID - L - Voice 3 (Write Only) - PW HI
ESID_SIDR_V3_CTRL       = $AED112 ;SID - L - Voice 3 (Write Only) - CTRL REG
ESID_SIDR_V3_ATCK_DECY  = $AED113 ;SID - L - Voice 3 (Write Only) - ATTACK / DECAY
ESID_SIDR_V3_SSTN_RLSE  = $AED114 ;SID - L - Voice 3 (Write Only) - SUSTAIN / RELEASE
ESID_SIDR_FC_LO         = $AED115 ;SID - L - Filter (Write Only) - FC LOW
ESID_SIDR_FC_HI         = $AED116 ;SID - L - Filter (Write Only) - FC HI
ESID_SIDR_RES_FILT      = $AED117 ;SID - L - Filter (Write Only) - RES / FILT
ESID_SIDR_MODE_VOL      = $AED118 ;SID - L - Filter (Write Only) - MODE / VOL
ESID_SIDR_POT_X         = $AED119 ;SID - L - Misc (Read Only) - POT X (C256 - NOT USED)
ESID_SIDR_POT_Y         = $AED11A ;SID - L - Misc (Read Only) - POT Y (C256 - NOT USED)
ESID_SIDR_OSC3_RND      = $AED11B ;SID - L - Misc (Read Only) - OSC3 / RANDOM
ESID_SIDR_ENV3          = $AED11C ;SID - L - Misc (Read Only)  - ENV3
ESID_SIDR_NOT_USED0     = $AED11D ;SID - L - NOT USED
ESID_SIDR_NOT_USED1     = $AED11E ;SID - L - NOT USED
ESID_SIDR_NOT_USED2     = $AED11F ;SID - L - NOT USED

ESID_ETHERNET_REG       = $AEE000