format ELF64
public _start

section '.text' executable
_start:
    cmp qword [rsp], 4
    jne error
    mov rsi, [rsp + 16]
    call parse_number
    mov r12, rax
    mov rsi, [rsp + 24]
    call parse_number
    mov r13, rax
    mov rsi, [rsp + 32]
    call parse_number
    mov r14, rax
    cmp r12, 0
    je error
    cmp r13, 0
    je error
    cmp r14, 0
    je error
    mov rax, r13
    mov rdx, rax
    sar rdx, 63
    idiv r13
    mov rdx, rax
    sar rdx, 63
    idiv r12
    mov rdx, rax
    sar rdx, 63
    idiv r12
    mov rdx, rax
    sar rdx, 63
    idiv r14
    call print_number
    call exit

include 'io.inc'
