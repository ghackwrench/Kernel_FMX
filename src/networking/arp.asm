            .al
            .xl
            .autsiz

arp         .namespace

recv
    ; X->packet; packet is ultimately dropped.

      ; Only IPv4 ARPs; IPv6 uses NDP.
      
        lda     pbuf.eth.arp.htype,x
        xba
        cmp     #$0001  ; Ethernet
        bne     _drop
        
        lda     pbuf.eth.arp.ptype,x
        xba
        cmp     #$0800  ; IPv4
        bne     _drop
        
        lda     pbuf.eth.arp.hlen,x ; and plen
        xba
        cmp     #$0604  ; 6 ether, 4 ip
        bne     _drop

      ; Dispatch based on operation and contents
      
        lda     pbuf.eth.arp.oper,x
        xba

        cmp     #$0002      ; reply
        beq     _record
        
        cmp     #$0001      ; request or broadcast
        bne     _drop       ; Invalid arp packet

        lda     kernel.net.pbuf.eth.arp.tpa+0,x 
        eor     kernel.net.pbuf.eth.arp.spa+0,x 
        bne     _request    ; not a broadcast

        lda     kernel.net.pbuf.eth.arp.tpa+2,x 
        eor     kernel.net.pbuf.eth.arp.spa+2,x 
        bne     _request    ; not a broadcast

        ; Broadcast; fall-through to record.

_record 
        jsr     arp_insert
_drop   jmp     kernel.net.pbuf_free_x

_request

      ; Just need to know if this is for us
        lda     kernel.net.pbuf.eth.arp.tpa+0,x
        eor     kernel.net.conf.ip_addr+0
        bne     _drop
        lda     kernel.net.pbuf.eth.arp.tpa+2,x
        eor     kernel.net.conf.ip_addr+2
        bne     _drop

        jsr     arp_reply
        txa
        jmp     hardware.lan9221.eth_packet_send
        
arp_insert:
        rts

arp_reply
    ; Converts an ARP request to an ARP response.
    ; X -> ARP request packet

      ; Set operation to "reply"
        lda     #$0002
        xba
        sta     pbuf.eth.arp.oper,x

      ; Copy source MAC to dest MAC
        lda     pbuf.eth.s_mac+0,x
        sta     pbuf.eth.d_mac+0,x
        sta     pbuf.eth.arp.tha+0,x    

        lda     pbuf.eth.s_mac+2,x
        sta     pbuf.eth.d_mac+2,x
        sta     pbuf.eth.arp.tha+2,x    

        lda     pbuf.eth.s_mac+4,x
        sta     pbuf.eth.d_mac+4,x
        sta     pbuf.eth.arp.tha+4,x 
        
      ; swap source IP with dest IP
        jsr     swap_ip

      ; Insert our source MAC
        lda     kernel.net.conf.eth_mac+0
        sta     pbuf.eth.arp.sha+0,x        
        sta     pbuf.eth.s_mac+0,x
       
        lda     kernel.net.conf.eth_mac+2
        sta     pbuf.eth.arp.sha+2,x        
        sta     pbuf.eth.s_mac+2,x
       
        lda     kernel.net.conf.eth_mac+4
        sta     pbuf.eth.arp.sha+4,x        
        sta     pbuf.eth.s_mac+4,x
       
        rts

swap_ip
        phy

        lda     pbuf.eth.arp.spa+0,x
        tay
        lda     pbuf.eth.arp.tpa+0,x
        sta     pbuf.eth.arp.spa+0,x
        tya
        sta     pbuf.eth.arp.tpa+0,x

        lda     pbuf.eth.arp.spa+2,x
        tay
        lda     pbuf.eth.arp.tpa+2,x
        sta     pbuf.eth.arp.spa+2,x
        tya
        sta     pbuf.eth.arp.tpa+2,x

        ply
        rts

        .endn
