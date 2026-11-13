format ELF64
public _start

section '.text' executable
_start:
    mov r10, 1000000
    call read_number
    mov r12, rax
    mov ebx, 10
.loop:
    cmp rbx, r12
    ja finish
    mov rax, rbx
    xor edx, edx
    mov ecx, 10
    div rcx
    mov r8, rdx
    xor edx, edx
    div rcx
    mov r9, rdx
    test r8, r8
    jz .next
    test r9, r9
    jz .next
    mov rax, rbx
    xor edx, edx
    div r8
    test rdx, rdx
    jnz .next
    mov rax, rbx
    xor edx, edx
    div r9
    test rdx, rdx
    jnz .next
    mov rax, rbx
    call print_number
.next:
    inc rbx
    jmp .loop

include 'io.inc'
