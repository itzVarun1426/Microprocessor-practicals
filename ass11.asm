section .data
    msg db "Enter no please: "
    msg_len equ $ - msg
    result db 0, 0, 0, 0        ; To store 4 hex digits
    newline db 10

section .bss
    num resb 2

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; Read input (2 bytes: number + newline)
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 2
    syscall

    ; Convert ASCII to number
    movzx bx, byte [num]
    sub bl, '0'

    ; Check for valid range (0–9)
    cmp bl, 9
    ja exit_program

    ; Calculate factorial recursively
    mov ax, 1
    call fact   ; result in AX

    ; Save AX to another register before converting
    mov cx, ax      ; copy factorial result to CX
    mov rsi, result
    mov rdi, 4      ; 4 hex digits

.hex_loop:
    dec rdi
    mov ax, cx
    shr ax, 4
    shl ax, 4
    xor ax, cx
    and al, 0Fh
    cmp al, 9
    jbe .digit
    add al, 7
.digit:
    add al, '0'
    mov [rsi + rdi], al
    shr cx, 4
    test rdi, rdi
    jnz .hex_loop

    ; Print result
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 4
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

; Recursive factorial: AX = factorial(BX)
fact:
    cmp bx, 1
    jbe .done
    push bx
    dec bx
    call fact
    pop bx
    mul bx
.done:
    ret

