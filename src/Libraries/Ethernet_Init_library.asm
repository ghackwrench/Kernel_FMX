
; Simple Init For the ESID and EVID

ip_info
        .byte   192, 168, 1, 122
        .byte   255,255,255,0
        .byte   192,168,1,1

                
SIMPLE_INIT_ETHERNET_CTRL   .proc

        php

        sep     #$30
        lda     GABE_MSTR_CTRL
        ora     #GABE_CTRL_PWR_LED
        sta     GABE_MSTR_CTRL
        rep     #$30

        phb
        phk
        plb
        ldy     #<>ip_info
        jsl     kernel.net.user.init
        plb
        bcs     _done

        sep     #$30
        lda     GABE_MSTR_CTRL
        and     #~GABE_CTRL_PWR_LED
        sta     GABE_MSTR_CTRL
        rep     #$30
        .al
        .xl

      ; Allocate our DP interface buffer
        tsc
        sec
        sbc     #kernel.net.user.udp_info.size
        tcs
        inc     a
        tax
        
      ; Use the display as our data buffer
        lda     #$a100
        sta     kernel.net.user.udp_info.buffer+0,d,x
        lda     #$af
        sta     kernel.net.user.udp_info.buffer+2,d,x
        lda     #5
        sta     kernel.net.user.udp_info.buflen,d,x

_loop   jsl     kernel.net.user.udp_recv
        beq     _loop
        lda     kernel.net.user.udp_info.copied,d,x
        and     #$ff
        ora     #$2000
        clc
        adc     #'0'
        sta     $afa090
        jmp     _loop

_done   plp
        rtl
        


WaitforittobeReady:
                LDA @l ESID_ETHERNET_REG + $84
                AND #$0001
                CMP #$0001 ; This is to check that the Controller is ready to roll
                BNE WaitforittobeReady
                ; This is for Debug Purpose
                LDA @l ESID_ETHERNET_REG + $52 ;Chip ID (0x9221)
                LDA @l ESID_ETHERNET_REG + $50 ;Chip Revision
                LDA @l ESID_ETHERNET_REG + $64
                LDA @l ESID_ETHERNET_REG + $66                
                ; Setup the LED
                LDA #$0000
                STA @l ESID_ETHERNET_REG + $88
                LDA #$7000
                STA @l ESID_ETHERNET_REG + $8A
                ; Setup a MAC Address
                ; We are going to force a MAC Address for the time being
                LDA #$0002 ; Accessing CSR INDEX 2 MAC Address (High)
                STA @l ESID_ETHERNET_REG + $A4
                LDA #$000B
                STA @l ESID_ETHERNET_REG + $A8
                LDA #$0000 
                STA @l ESID_ETHERNET_REG + $AA
                 ;Asking to Write the 32bit in the MAC Address Registers & Pol
                JSR MAC_ACCESS_WAIT_FOR_COMPLETION
                LDA #$0003 ; Accessing CSR INDEX 3 MAC Address (low)
                STA @l ESID_ETHERNET_REG + $A4
                LDA #$DC7F
                STA @l ESID_ETHERNET_REG + $A8
                LDA #$ABD7 
                STA @l ESID_ETHERNET_REG + $AA
                 ;Asking to Write the 32bit in the MAC Address Registers & Pol
                JSR MAC_ACCESS_WAIT_FOR_COMPLETION
                ; Now, let's enable the RXE and TXE in the MAC 
                LDA #$0001 ; Accessing CSR INDEX 2 MAC Address (High)
                STA @l ESID_ETHERNET_REG + $A4
                LDA #$000C
                STA @l ESID_ETHERNET_REG + $A8
                LDA #$0004 
                STA @l ESID_ETHERNET_REG + $AA
                 ;Asking to Write the 32bit in the MAC Address Registers & Pol
                JSR MAC_ACCESS_WAIT_FOR_COMPLETION                
                RTL 
.pend
; This is Write Register / Poll Only, the bit 30 would have to be set in order to Read Back
MAC_ACCESS_WAIT_FOR_COMPLETION .proc
                ;Asking to Write the 32bit in the MAC Address Registers
                LDA #$8000 ; CsR busy bit is a status but also the Command Execution bit
                STA @l ESID_ETHERNET_REG + $A6
WaitForCompletion:
                LDA @l ESID_ETHERNET_REG + $A6
                AND #$8000
                CMP #$8000 
                BEQ WaitForCompletion
                RTS
.pend