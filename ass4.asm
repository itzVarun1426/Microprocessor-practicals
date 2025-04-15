section .data
    msg     db 'The largest number is: '
    len     equ $ - msg
    arr     dd 1AAAAAA1h, 22h, 11h, 3ABCDEE3h, 444h

section .bss
    count   resb 1
    result  resb 15

section .text
    global _start

_start:
    ; Print message
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg
    mov     edx, len
    int     80h

    ; Initialize loop variables
    mov     byte [count], 5
    mov     eax, 0              ; EAX will store the current largest
    mov     esi, arr            ; ESI points to array

Loop1:
    cmp     eax, [esi]          ; Compare EAX with current array element
    jnc     next                ; If EAX >= [esi], skip update
    mov     eax, [esi]          ; Else, update EAX to current value

next:
    add     esi, 4              ; Move to next 32-bit element
    dec     byte [count]        ; Decrement count
    jnz     Loop1               ; Repeat if count not zero

    ; Convert result in EAX to ASCII hex for display
    mov     ebx, eax
    mov     esi, result
    mov     byte [count], 8     ; 8 nibbles (4 bytes = 8 hex digits)
    mov     cl, 4               ; Bit shift count

L1:
    rol     ebx, cl
    mov     dl, bl
    and     dl, 0Fh
    cmp     dl, 9
    jbe     L2
    add     dl, 7

L2:
    add     dl, 30h
    mov     [esi], dl
    inc     esi
    dec     byte [count]
    jnz     L1

    ; Add newline
    mov     byte [esi], 0Ah

    ; Print result
    mov     edx, 9
    mov     ecx, result
    mov     ebx, 1
    mov     eax, 4
    int     80h

    ; Exit program
    mov     eax, 1
    xor     ebx, ebx
    int     80h
