            .al
            .xl
            .autsiz

user        .namespace

ip_info     .struct
ip          .fill   4   ; Local ipv4 address in network order
mask        .fill   4   ; Local ipv4 netmask in network order
default     .fill   4   ; Default ipv4 route in network order
            .ends

udp_info    .struct
local_port  .word   ?   ; local port #, little-endian
remote_ip   .fill   4   ; ipv4 address of remote machine, network order
remote_port .word   ?   ; remote port #, little endian
buffer      .dword  ?   ; 24-bit address of your data
buflen      .word   ?   ; length of the above buffer in bytes
copied      .word   ?   ; number of bytes copied in/out of the above buffer
size
            .ends

nfunc       .macro  vector
            jsr     call
            rtl
            .word   <>\vector
            .endm

; Unless otherwise noted, all calls are mx agnostic and preserve all registers.

; Initialize the NIC, arp, and route tables.
; B:Y points to an ip_info structure containing the configuration.
; Carry set if no network card is found.
init    
            #nfunc  net.init

; Send a UDP packet 
; X points to the associated udp_info structure in bank0.
; On success, X->copied is set to the number of bytes sent.
; Carry set (bcs) on error (no route to host).
udp_send    
            #nfunc  net.udp_send

; Receive a UDP packet
; X points to a udp_info structure in bank0.
; On success, the udp_info structure and its buffer are updated.
; Z set (beq) if no packets are waiting to be processed.
udp_recv
            #nfunc  net.udp_recv


call
    ; Calls the address at (2,s) in 16/16 mode w/ D=X and B=K.
    ; Preserves all registers and modes.  The
    ; czvn flags are returned as the remote call
    ; left them.

        czvn = 1+2+64+128 

        rep     #czvn       ; Clear czvn
        php
        rep     #255-8      ; Clear all but i
        phy
        phx
        phd
        phb
        pha                 ; [a:b:d:x:y:p:rts:rtl]

      ; Set X to the rts value (two before the vector in bank k)
        lda     11,s        ; return vector
        tax

      ; Set D to the original X value
        lda     6,s         ; X (new D)
        tcd

        .byte   $fc,2,0   ; jsr (2,x), but the assembler won't let me...

      ; Propagate the czvn condition codes.
        php
        sep     #$20
        lda     1,s
        and     #czvn
        ora     11,s
        sta     11,s
        plp
        
        pla
        plb
        pld
        plx
        ply
        plp
        rts

            .endn

