            .al
            .xl
            .autsiz

lib         .namespace
            .endn
            .include    "lib_deque.asm"

            .include    "lan9221.asm"

kernel      .namespace
net         .namespace

            .include    "user.asm"
            .include    "packet.asm"
            .include    "arp.asm"
            .include    "net_ip.asm"
            .include    "net_udp.asm"

ip          .namespace
udp_send    
            clc
            rts
            .endn
            

conf        .namespace
eth_mac     .byte   $c2 ; NIC's MAC prefix; the rest is the IP address.
            .byte   $56 ; c2:56: just happens to be a "local assignment" prefix :).
ip_addr     .fill   4   ; Local IP address, MUST IMMEDIATELY FOLLOW THE MAC!
ip_mask     .fill   4   ; Local netmask
default     .dword  0   ; Default route (0 = local only)
            .endn
        
cp_ip       .macro  src, dest
            lda     0+\src,y
            sta @l  0+\dest
            lda     2+\src,y
            sta @l  2+\dest
            .endm

init
            #cp_ip  user.ip_info.ip,        conf.ip_addr
            #cp_ip  user.ip_info.mask,      conf.ip_mask
            #cp_ip  user.ip_info.default,   conf.default

            phk
            plb
            jsr     pbuf_init
            jsr     hardware.lan9221.eth_open

            rts

rx_queue    .dstruct    lib.deque_t

rx_enqueue
        #lib.deque_enque rx_queue, x, kernel.net.pbuf.deque, @l
        rts 

packet_recv    
    ; Read and process packets from the lan until its queue is empty,
    ; then return whatever might be at the head of the received UDP queue.
    ; If anything is available, it'll be in X (non-zero)
    ; Otherwise, the Z flag will be set.

_loop   jsr     hardware.lan9221.eth_packet_recv
        tax
        beq     _deque
        lda     pbuf.eth.type,x
        xba
        cmp     #$0800
        beq     _ipv4
        cmp     #$0806
        beq     _arp
        jsr     kernel.net.pbuf_free_x  ; We don't handle anything else.
        jmp     _loop
        
_arp    jsr     arp.recv
        jmp     _loop

_ipv4   jsr     ip_check
        jmp     _loop

_deque        
        #lib.deque_deque rx_queue, x, kernel.net.pbuf.deque, @l
        rts

toggle
        sep     #$20
        lda     GABE_MSTR_CTRL
        eor     #GABE_CTRL_PWR_LED
        sta     GABE_MSTR_CTRL
        rep     #$20
        rts


udp_recv
    ; IN: X -> udp_info in bank 0
    ; If a packet is available, Z is clear (bne)
    ; If no packets were available, Z is set (beq)
            phk
            plb
            jsr     packet_recv
            beq     _out

          ; Copy the data out of the packet
            
            lda     pbuf.ipv4.src+0,x
            sta     user.udp_info.remote_ip,d
            lda     pbuf.ipv4.src+2,x
            sta     user.udp_info.remote_ip+2,d
            
            lda     pbuf.ipv4.udp.sport,x
            xba
            sta     user.udp_info.remote_port,d
            
            lda     pbuf.ipv4.udp.dport,x
            xba
            sta     user.udp_info.local_port,d
            
          ; Determine the copy size
            lda     pbuf.ipv4.udp.length,x
            xba
            sec
            sbc     #udp_t.size
            cmp     user.udp_info.buflen,d
            bcc     _length
            beq     _length
            lda     user.udp_info.buflen,d    ; Limit copy to buflen.
_length     sta     user.udp_info.copied,d    ; copied = # of bytes to copy    

            phx

          ; Set Y->user buffer offset
            ldy     #0
    
          ; Copy the data
            lsr     a
            bcc     _even
    
          ; Odd length, copy exactly one byte.
_odd        sep     #$20
            lda     pbuf.ipv4.udp.data,x
            sta     [user.udp_info.buffer],y
            inx
            iny
            rep     #$20
            jmp     _next
    
_even       lda     pbuf.ipv4.udp.data,x
            sta     [user.udp_info.buffer],y
            inx
            inx
            iny
            iny
_next       cpy     user.udp_info.copied,d
            bne     _even
    
            plx
            jsr     kernel.net.pbuf_free_x
    
_out        rts

.if false


udp_send
    ; IN: X -> udp_info in bank 0
    ; On success: carry clear and all registers preserved
    ; On failure: carry set, A=error, X and Y preserved

            jsr     ip.arp_resolve
            bcs     _out
            jmp     ip.udp_send
_out        rts        


.endif

            .endn
            .endn

