section .data  ; Data section
    msg1    db 'Enter string:'
    size1   equ $ - msg1

    msg2    db 10  ; Newline character
    size2   equ $ - msg2

section .bss   ; Uninitialized data
    string  resb 50   ; Buffer to hold input string
    temp    resb 1    ; Temporary char buffer
    len     resb 1    ; Length in bytes (only 1-byte space)

section .text
    global _start

_start:
    ; Print "Enter string:"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, size1
    int 80h

    ; Prepare for reading string
    mov ebx, string        ; EBX points to buffer
    mov byte [len], 0      ; Initialize length counter to 0

read_loop:
    push ebx               ; Save current buffer pointer
    mov eax, 3
    mov ebx, 0             ; stdin
    mov ecx, temp
    mov edx, 1             ; Read 1 byte
    int 80h
    pop ebx                ; Restore buffer pointer

    mov al, [temp]
    mov [ebx], al          ; Store character in string buffer
    inc byte [len]         ; Increment length
    inc ebx                ; Move buffer pointer

    cmp byte [temp], 10    ; If Enter/newline pressed
    jne read_loop

    ; Clean up newline from buffer
    dec ebx
    dec byte [ebx]
    dec byte [len]

    ; Display length (not in decimal or hex, just raw byte value)
    mov eax, 4
    mov ebx, 1
    mov ecx, len
    mov edx, 1
    int 80h

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, size2
    int 80h

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
