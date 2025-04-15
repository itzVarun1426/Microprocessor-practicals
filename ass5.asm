section .data
    choice      db 'Enter your choice:', 0Ah, '1. Addition', 0Ah, '2. Subtraction', 0Ah, '3. Multiplication', 0Ah, '4. Division', 0Ah
    choicelen   equ $ - choice

    msg         db 'The addition is: ', 0Ah
    len         equ $ - msg

    msg1        db 'The subtraction is: ', 0Ah
    len1        equ $ - msg1

    msg2        db 'The multiplication is: ', 0Ah
    len2        equ $ - msg2

    msg3        db 'The division is: ', 0Ah
    len3        equ $ - msg3

    arr         dq 2222222222222222h, 11111h, 1111h, 1111h, 1111h
    temp        dq 0

section .bss
    count       resb 1
    result      resb 17
    result1     resb 17
    result2     resb 17
    result3     resb 17

%macro disp 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .text
    global _start

_start:
    disp choice, choicelen

    ; Read user input
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, temp
    mov     rdx, 8
    syscall

    mov     rcx, [temp]
    cmp     cl, 31h
    je      ch1
    cmp     cl, 32h
    je      ch2
    cmp     cl, 33h
    je      ch3
    cmp     cl, 34h
    je      ch4
    jmp     exit

ch1:
    call addition
    jmp exit

ch2:
    call subtraction
    jmp exit

ch3:
    call multiplication
    jmp exit

ch4:
    call division
    jmp exit

addition:
    disp msg, len
    mov     byte[count], 5
    mov     rax, 0
    mov     rsi, arr

.loop1:
    add     rax, [rsi]
    add     rsi, 8
    dec     byte[count]
    jnz     .loop1

    mov     rbx, rax
    mov     rsi, result
    mov     byte[count], 16
    mov     cl, 4
    call    display
    disp    result, 17
    ret

subtraction:
    disp msg1, len1
    mov     byte[count], 4
    mov     rsi, arr
    mov     rax, [rsi]
    add     rsi, 8

.loop2:
    sub     rax, [rsi]
    add     rsi, 8
    dec     byte[count]
    jnz     .loop2

    mov     rbx, rax
    mov     rsi, result1
    mov     byte[count], 16
    mov     cl, 4
    call    display
    disp    result1, 17
    ret

multiplication:
    disp msg2, len2
    mov     byte[count], 4
    mov     rsi, arr
    mov     rax, [rsi]
    add     rsi, 8

.loop3:
    mov     rcx, [rsi]
    mul     rcx
    add     rsi, 8
    dec     byte[count]
    jnz     .loop3

    mov     rbx, rax
    mov     rsi, result2
    mov     byte[count], 16
    mov     cl, 4
    call    display
    disp    result2, 17
    ret

division:
    disp msg3, len3
    mov     byte[count], 4
    mov     rsi, arr
    mov     rax, [rsi]
    add     rsi, 8

.loop4:
    mov     rcx, [rsi]
    div     rcx
    add     rsi, 8
    dec     byte[count]
    jnz     .loop4

    mov     rbx, rax
    mov     rsi, result3
    mov     byte[count], 16
    mov     cl, 4
    call    display
    disp    result3, 17
    ret

; Convert RBX to hexadecimal and store in buffer at RSI
display:
.l1:
    rol     rbx, cl
    mov     dl, bl
    and     dl, 0Fh
    cmp     dl, 9
    jbe     .l2
    add     dl, 7
.l2:
    add     dl, '0'
    mov     [rsi], dl
    inc     rsi
    dec     byte[count]
    jnz     .l1
    mov     byte [rsi], 0Ah
    ret

exit:
    mov     rax, 60
    xor     rdi, rdi
    syscall
