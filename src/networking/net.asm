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
            ;.include    "ip.asm"
            ;.include    "eth.asm"


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

udp_recv
            phk
            plb
            jmp     packet_recv

rx_queue    .dstruct    lib.deque_t

packet_recv    
    ; Read and process packets from the lan until its queue is empty,
    ; then return whatever might be at the head of the received UDP queue.
    ; If anything is available, it'll be in X (non-zero)
    ; Otherwise, the Z flag will be set.

_loop   jsr     hardware.lan9221.eth_packet_recv
        beq     _deque
        tax
  jsr _toggle
        lda     pbuf.eth.type,x
        xba
        cmp     #$0800
        beq     _ipv4
        cmp     #$0806
        beq     _arp
        jmp     kernel.net.pbuf_free_x  ; We don't handle anything else.
        
_arp    jsr     arp.recv
        jmp     _loop

_ipv4   jsr     ip_check
        jmp     _loop

_deque        
        #lib.deque_deque rx_queue, x, kernel.net.pbuf.deque, @l
        rts

_toggle
        sep     #$30
        lda     GABE_MSTR_CTRL
        eor     #GABE_CTRL_PWR_LED
        sta     GABE_MSTR_CTRL
        rep     #$30
        rts



.if false


udp_send
    ; IN: X -> udp_info in bank 0
    ; On success: carry clear and all registers preserved
    ; On failure: carry set, A=error, X and Y preserved

            jsr     ip.arp_resolve
            bcs     _out
            jmp     ip.udp_send
_out        rts        


udp_recv
    ; IN: X -> udp_info in bank 0
    ; If a packet is available, Z is clear (bne)
    ; If no packets were available, Z is set (beq)

            jsr     eth.eth_recv
            jsr     packet.udp_pop
            beq     _out
    
          ; Copy the data out of the packet
            
            lda     ip.src+0,x
            sta     udp_info.remote_ip,d
            lda     ip.src+2,x
            sta     udp_info.remote_ip+2,d
            
            lda     ip.udp.sport,x
            sta     udp_info.remote_port,d
            
            lda     ip.udp.dport,x
            sta     udp_info.local_port,d
            
          ; Determine the copy size
            lda     ip.udp.length,x
            cmp     udp_info.length,d
            bcc     _length
            beq     _length
            lda     udp_info.length,d    ; Limit copy to buflen.
_length     sta     udp_info.copied,d    ; copied = # of bytes to copy    

            phx

          ; Set Y->user buffer offset
            ldy     #0
    
          ; Copy the data
            lsr     a
            beq     _even
    
          ; Odd length, copy exactly one byte.
_odd        sep     #$20
            lda     ip.udp.data,x
            sta     [udp_info.buffer],y
            inx
            iny
            rep     #$20
            jmp     _next
    
_even       lda     ip.udp.data,x
            sta     [udp_info.buffer],y
            inx
            inx
            iny
            iny
_next       cpy     udp_info.copied,d
            bne     _even
    
            plx
            jsr     packet.udp_free
    
_out        rts
.endif

            .endn
            .endn

