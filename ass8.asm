section .data

sblock db 10h, 20h, 30h, 40h, 50h, 60h, 70h   
dblock times 7 db 0h                         

smsg db 10, "Source Block: "
smsg_len equ $ - smsg

dmsg db 10, "Destination Block: "
dmsg_len equ $ - dmsg

space db ' ', 0
nline db 10, 0

before db 10, "# Before Transfer:", 10
blen equ $ - before

after db 10, "# After Transfer:", 10
alen equ $ - after

topic db 10, "# Assignment-6: Overlapped Block Transfer #", 10
tlen equ $ - topic

section .bss
char_ans resb 2

%macro print 2
    mov rax, 1       
    mov rdi, 1       
    mov rsi, %1     
    mov rdx, %2      
    syscall
%endmacro

%macro exit 0
    mov rax, 60      
    xor rdi, rdi     
    syscall
%endmacro

section .text
global _start

_start:

    print topic, tlen

    print before, blen
    print smsg, smsg_len
    mov rsi, sblock
    call block_display

    print dmsg, dmsg_len
    mov rsi, dblock
    call block_display

    call block_transfer_overlapping

    print nline, 1
    print after, alen

    print smsg, smsg_len
    mov rsi, sblock
    call block_display

    print dmsg, dmsg_len
    mov rsi, dblock
    call block_display

    print nline, 1
    exit

block_transfer_overlapping:
    mov rsi, sblock
    mov rdi, dblock
    mov rcx, 7       

    ; Check for overlap: If dest > source, copy in reverse
    cmp rdi, rsi     
    ja copy_backward ; If dest > source, jump to backward copy

copy_forward:
    cld              
    rep movsb        
    ret

copy_backward:
    std              
    add rsi, rcx     ; Move to the last byte of the source
    add rdi, rcx     ; Move to the last byte of the destination
    dec rsi
    dec rdi
    rep movsb        
    cld              
    ret

block_display:
    mov rbp, 7       

next_num:
    mov al, [rsi]   
    push rsi
    call display
    print space, 1  
    pop rsi
    inc rsi
    dec rbp
    jnz next_num
    ret

display:
    mov rbx, 16      
    mov rcx, 2      
    mov rsi, char_ans + 1  

next_digit:
    xor rdx, rdx     
    div rbx          
    cmp dl, 9h
    jbe add30
    add dl, 07h      

add30:
    add dl, 30h      
    mov [rsi], dl
    dec rsi
    dec rcx
    jnz next_digit

    print char_ans, 2  
    ret

