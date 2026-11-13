format ELF64
public _start

section '.text' executable
_start:
    cmp qword [rsp], 2
    jne error
    mov rsi, [rsp + 16]
    cmp byte [rsi], 0
    je error
    cmp byte [rsi + 1], 0
    jne error
    xor rax, rax
    mov al, [rsi]
    cmp rax, 127
    ja error
    call print_number
    call exit

include 'io.inc'
