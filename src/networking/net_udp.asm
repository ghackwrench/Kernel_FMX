        .al
        .xl
        .autsiz

ip_udp
        jsr     udp_checksum
        inc     a
        bne     _done
        jmp     rx_enqueue
_done   jmp     pbuf_free_x

        
update_udp_checksum
        lda     #0
        sta     pbuf.ipv4.udp.check,x
        jsr     udp_checksum
        eor     #$ffff
        xba
        sta     pbuf.ipv4.udp.check,x
        rts

udp_checksum
        phy

      ; Make sure the last byte is zero
      ; Should move to the ip layer.
        phx
        lda     pbuf.ipv4.len,x
        xba
        clc
        adc     1,s
        tax
        lda     #0
        sta     pbuf.ipv4,x
        plx

        ; Compute size of UDP header + data.
        lda     pbuf.ipv4.len,x
        xba
        sec
        sbc     #ip_t.size
        pha                 ; Save for pseudo-header.
        bit     #1
        beq     _aligned
        inc     a
_aligned

        ; Compute the initial checksum, result in A.
        tay
        lda     #ip_t.size
        jsr     header_checksum
        
        ; Add in "UDP Length" from the pseudo-header
        clc
        adc     1,s
        sta     1,s
        
        ; Add in the protocol.
        lda     pbuf.ipv4.proto,x
        and     #$ff
        adc     1,s
        sta     1,s
        
        ; Add in the source address.
        lda     pbuf.ipv4.src+0,x
        jsr     _sum
        lda     pbuf.ipv4.src+2,x
        jsr     _sum
        
        ; Add in the destination address.
        lda     pbuf.ipv4.dest+0,x
        jsr     _sum
        lda     pbuf.ipv4.dest+2,x
        jsr     _sum
        
        ; Complete the one's complement
        pla
        adc     #0
        
        ply
        rts

_sum    xba
        adc     3,s
        sta     3,s
        rts

.if false
udp_send:
    ; Y -> send_msg

        jsr     pbuf_alloc_x
        bne     _fill
        rts
    
_fill

    ; do this in the router...
        lda     #0
        sta     kernel.net.pbuf.eth.d_mac+0,x
        lda     #$0800
        xba
        sta     kernel.net.pbuf.eth.type+0,x

        lda     #$45                ; Version=4, IHL=5, TOS=0
        sta     pbuf.ipv4.ihl,x 
        ; Total length TBD
        lda     #0                  ; Frag ID=0 (no fragmentation)
        sta     pbuf.ipv4.id,x
        lda     #$40                ; May fragment
        sta     pbuf.ipv4.flags,x
        lda     #$1140              ; Protocol=UDP, TTL=$40
        sta     pbuf.ipv4.ttl,x

        ; Copy source address
        lda     udp_msg.src_ip+0,b,y
        sta     pbuf.ipv4.src+0,x
        lda     udp_msg.src_ip+2,b,y
        sta     pbuf.ipv4.src+2,x

        ; Copy dest address
        lda     udp_msg.dest_ip+0,b,y
        sta     pbuf.ipv4.dest+0,x
        lda     udp_msg.dest_ip+2,b,y
        sta     pbuf.ipv4.dest+2,x

      ; Copy the source and dest ports
        lda     udp_msg.src_port,b,y
        xba
        sta     pbuf.ipv4+udp.sport,x
        lda     udp_msg.dest_port,b,y
        xba
        sta     pbuf.ipv4+udp.dport,x
        
      ; Copy the data
        jsr     copy_msg_data
        
      ; Set the UDP length
        lda     udp_msg.length,b,y
        clc
        adc     #udp.size - ip.size
        xba
        sta     pbuf.ipv4+udp.length,x
        xba
        
      ; Set the IP length
        clc
        adc     #ip.size
        xba
        sta     pbuf.ipv4.len,x

      ; Update the checksums
        phx
        txa
        clc
        adc     #<>kernel.net.pbuf.eth.data
        tax
      plx
        jsr     update_udp_checksum
        jsr     update_ip_checksum
      ;plx

    ; Proof of concept; prolly best done at the router.

      ; Set the raw (ethernet) packet length
        lda     pbuf.ipv4.len,x
        xba
        clc
        adc     #ethernet.packet_t.data
        sta     pbuf.length,x

      ; Set the ethernet frame type to IPv4
        lda     #$0800
        xba
        sta     pbuf.eth.type,x

      ; Clear the dest MAC address
        lda     #0
        sta     pbuf.eth.d_mac+0,x
        sta     pbuf.eth.d_mac+2,x
        sta     pbuf.eth.d_mac+4,x

      ; Send the packet
        jmp     route.dispatch

copy_msg_data

        lda     udp_msg.length,b,y
        beq     _done

        phx
        phy

        clc
        adc     udp_msg.data,b,y
        pha

      ; Buffer start in Y
        lda     udp_msg.data,b,y
        tay
        
_loop   lda     0,b,y
        sta     kernel.net.pbuf.eth.data+udp.data,x
        inx
        inx
        iny
        iny
        tya
        cmp     1,s
        bcc     _loop
        
        pla     ; count
        ply     ; original
        plx     ; original
        
_done   rts

.endif
