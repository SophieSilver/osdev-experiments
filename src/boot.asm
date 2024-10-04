    BITS 16
    ORG 0x7C00              ; bootloader loads at this address 
    SECTION .boot_sector

start:
    mov di, msg
    mov si, msg_len
    call print_str
    jmp end

; di - ptr: *const u8
; si - len: u16
print_str:
    push ax
    push bx

    mov bh, 0           ; first page
    mov ah, 0x0E        ; write text in teletype mode

    add si, di          ; si = turning length into an end pointer,
                        ; saves an instruction inside the loop
.loop:
    cmp di, si
    je .loop_end

    mov al, [di]        ; load the char pointed to by di and increment the pointer
    inc di

    int 0x10            ; actually print

    jmp .loop
.loop_end:

    pop bx
    pop ax
    ret

end:
    pause
    jmp end

; DATA:
msg: db `Hello world\r\n`
msg_len: equ $ - msg

; put magic at the end of the boot sector
    TIMES 512 - ($ - $$) - 2 DB 0
    DW 0xAA55

