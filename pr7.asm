section .data
    M1 db 10, 'Sorry!!! Processor is in real mode', 10
    M1_len equ $ - M1

    Pmodemsg db 10, 'Processor is in protected mode', 10
    Pmsg_len equ $ - Pmodemsg

    Gdtmsg db 10, 'GDTR contents are::', 10
    Gmsg_len equ $ - Gdtmsg

    Ldtmsg db 10, 'LDTR contents are::', 10
    Lmsg_len equ $ - Ldtmsg

    Idtmsg db 10, 'IDTR contents are::', 10
    Imsg_len equ $ - Idtmsg

    Mswmsg db 10, 'Machine Status Word::', 10
    Mmsg_len equ $ - Mswmsg

    Colmsg db ':', 10
    Nwline db 10

section .bss
    Gdtr resb 6
    Ldtr resb 2
    Idtr resb 6
    Msw resw 1
    Tr resw 1
    Dnum_buff resb 4

%macro disp 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .text
    global _start

_start:
    smsw eax      ; Store Machine Status Word (MSW) in EAX
    bt eax, 0     ; Test bit 0 of EAX (checks if in protected mode)
    jc prmode     ; Jump if Carry flag is set (Protected Mode)

    disp M1, M1_len  ; Display "Real Mode"
    jmp nxt1

prmode:
    disp Pmodemsg, Pmsg_len  ; Display "Protected Mode"

nxt1:
    sgdt [Gdtr]    ; Store GDTR
    sldt [Ldtr]    ; Store LDTR
    sidt [Idtr]    ; Store IDTR
    str [Tr]       ; Store Task Register

    disp Gdtmsg, Gmsg_len
    mov bx, [Gdtr+4]
    call disp_num
    mov bx, [Gdtr+2]
    call disp_num
    disp Colmsg, 1
    mov bx, [Gdtr]
    call disp_num

    disp Ldtmsg, Lmsg_len
    mov bx, [Ldtr]
    call disp_num

    disp Idtmsg, Imsg_len
    mov bx, [Idtr+4]
    call disp_num
    mov bx, [Idtr+2]
    call disp_num
    disp Colmsg, 1
    mov bx, [Idtr]
    call disp_num

    disp Mswmsg, Mmsg_len
    mov bx, [Msw]
    call disp_num

exit:
    disp Nwline, 1
    mov eax, 1
    mov ebx, 0
    int 80h

disp_num:
    mov esi, Dnum_buff
    mov ecx, 4
up1:
    rol bx, 4
    mov dl, bl
    and dl, 0Fh
    add dl, 30h
    cmp dl, 39h
    jbe skip1
    add dl, 07h
skip1:
    mov [esi], dl
    inc esi
    loop up1
    disp Dnum_buff, 4
    ret
