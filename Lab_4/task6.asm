format ELF64
public _start

section '.text' executable
_start:
    mov r10, 1000000
    call read_number
    mov r12, rax
    mov ebx, 5
    xor r13, r13
.loop:
    cmp rbx, r12
    ja .done
    mov rax, rbx
    xor edx, edx
    mov ecx, 3
    div rcx
    test rdx, rdx
    jz .next
    mov rax, rbx
    xor edx, edx
    mov ecx, 7
    div rcx
    test rdx, rdx
    jz .next
    inc r13
.next:
    add rbx, 5
    jmp .loop
.done:
    mov rax, r13
    call print_number
    jmp finish

include 'io.inc'
