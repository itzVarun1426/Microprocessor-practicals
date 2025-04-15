section .data
    msg1 db 10, 13, "Enter 5 64-bit numbers"
    len1 equ $ - msg1

    msg2 db 10, 13, "Entered 5 64-bit numbers are: "
    len2 equ $ - msg2

section .bss
    array   resb 200     ; Reserve space for 5 numbers (each 16 bytes + 1 newline)
    counter resb 1       ; Loop counter

section .text
    global _start

_start:

    ; Print first message
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, msg1
    mov rdx, len1
    syscall

    ; Read 5 numbers from user
    mov byte [counter], 5
    mov rbx, 0

read_loop:
    mov rax, 0           ; sys_read
    mov rdi, 0           ; stdin
    mov rsi, array
    add rsi, rbx         ; move to next input block
    mov rdx, 17          ; 16 characters + newline
    syscall

    add rbx, 17          ; next block
    dec byte [counter]
    jnz read_loop

    ; Print second message
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, msg2
    mov rdx, len2
    syscall

    ; Display the entered numbers
    mov byte [counter], 5
    mov rbx, 0

display_loop:
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, array
    add rsi, rbx
    mov rdx, 17          ; print 17 bytes
    syscall

    add rbx, 17
    dec byte [counter]
    jnz display_loop

    ; Exit
    mov rax, 60          ; sys_exit
    xor rdi, rdi         ; status 0
    syscall
