section .data
    array db  5, -3, 7, -1, -4, 9, 0, -2, 6, -8   ; Signed 8-bit numbers
    length equ $ - array   ; Length of array
    pos_msg db "Positive count: ", 0
    neg_msg db "Negative count: ", 0
    newline db 10, 0      ; Newline character

section .bss
    pos_count resb 1       ; Variable for positive count
    neg_count resb 1       ; Variable for negative count
    pos_buffer resb 4      ; Buffer for positive count (ASCII)
    neg_buffer resb 4      ; Buffer for negative count (ASCII)

section .text
    global _start

_start:
    ; Initialize registers
    mov rcx, length        ; Loop counter
    mov rsi, array         ; Pointer to array
    xor r8b, r8b           ; pos_count = 0
    xor r9b, r9b           ; neg_count = 0

loop_start:
    cmp rcx, 0             ; If array is empty, exit loop
    je done

    movsx ax, byte [rsi]   ; Load sign-extended value into AX (16-bit)
    bt ax, 7               ; Test sign bit (7th bit)
    jc is_negative         ; If sign bit is 1, jump to is_negative

    test al, al            ; If zero, skip counting
    jz next_element

    inc r8b                ; Increment positive count
    jmp next_element

is_negative:
    inc r9b                ; Increment negative count

next_element:
    inc rsi                ; Move to next element
    dec rcx                ; Decrement counter
    jmp loop_start

done:
    ; Store counts in memory
    mov [pos_count], r8b
    mov [neg_count], r9b

    ; Print "Positive count: " message
    mov rdi, pos_msg       ; Load message address
    call print_string      ; Print message

    ; Convert and Print Positive Count
    movzx rdi, byte [pos_count]  ; Load positive count
    mov rsi, pos_buffer           ; Buffer for result
    call int_to_ascii              ; Convert to ASCII
    mov rdi, rsi                  ; Load buffer address
    call print_string              ; Print number

    ; Print newline after positive count
    mov rdi, newline
    call print_string

    ; Print "Negative count: " message
    mov rdi, neg_msg       ; Load message address
    call print_string      ; Print message

    ; Convert and Print Negative Count
    movzx rdi, byte [neg_count]  ; Load negative count
    mov rsi, neg_buffer           ; Buffer for result
    call int_to_ascii              ; Convert to ASCII
    mov rdi, rsi                  ; Load buffer address
    call print_string              ; Print number

    ; Print newline after negative count
    call print_string

    ; Exit program
    mov rax, 60       ; syscall: exit
    xor rdi, rdi      ; status 0
    syscall

; ----------------------
; Convert integer to ASCII string
; ----------------------
int_to_ascii:
    mov rax, rdi       ; Move number into RAX for division
    mov rbx, 10        ; Divisor for decimal conversion
    lea rsi, [rsi + 3] ; Point to end of buffer
    mov byte [rsi], 0  ; Null-terminate the string

convert_loop:
    dec rsi
    xor rdx, rdx
    div rbx            ; RAX / 10, remainder in RDX
    add dl, '0'        ; Convert remainder to ASCII
    mov [rsi], dl
    test rax, rax
    jnz convert_loop   ; Repeat until RAX is zero
    ret

; ----------------------
; Print a string using syscall
; ----------------------
print_string:
    mov rax, 1          ; syscall: sys_write
    mov rdi, 1          ; stdout
    call get_string_length  ; Get correct string length
    syscall
    ret

; ----------------------
; Get the length of the ASCII string
; ----------------------
get_string_length:
    mov rdx, 0          ; Initialize length counter
find_length:
    cmp byte [rsi + rdx], 0  ; Check for null terminator
    je end_length
    inc rdx
    jmp find_length
end_length:
    ret

