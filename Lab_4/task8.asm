format ELF64
public _start

section '.text' executable
_start:
    mov r10, 999999999
    call read_number
    call insert_zeros
    call print_number
    jmp finish

insert_zeros:
    xor r8, r8
    mov r9, 10
    mov ecx, 10
.loop:
    xor edx, edx
    div rcx
    imul rdx, r9
    add r8, rdx
    test rax, rax
    jz .done
    imul r9, 100
    jmp .loop
.done:
    mov rax, r8
    ret

include 'io.inc'
