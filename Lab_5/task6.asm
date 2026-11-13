format ELF64
public _start

section '.bss' writable
input_buffer rb 4096
output_buffer rb 8192

section '.text' executable
_start:
    cmp qword [rsp], 3
    jne error
    mov eax, 2
    mov rdi, [rsp + 16]
    xor esi, esi
    syscall
    test rax, rax
    js error
    mov r12, rax
    mov eax, 2
    mov rdi, [rsp + 24]
    mov esi, 193
    mov edx, 644o
    syscall
    test rax, rax
    js error
    mov r13, rax
.read:
    xor eax, eax
    mov rdi, r12
    mov rsi, input_buffer
    mov edx, 4096
    syscall
    cmp rax, -4
    je .read
    test rax, rax
    js error
    jz .close
    mov r8, rax
    xor r9d, r9d
    xor r10d, r10d
.letter:
    mov al, [input_buffer + r9]
    mov [output_buffer + r10], al
    inc r10
    mov bl, al
    and bl, 0DFh
    cmp bl, 'A'
    jb .next
    cmp bl, 'Z'
    ja .next
    cmp bl, 'A'
    je .next
    cmp bl, 'E'
    je .next
    cmp bl, 'I'
    je .next
    cmp bl, 'O'
    je .next
    cmp bl, 'U'
    je .next
    mov [output_buffer + r10], al
    inc r10
.next:
    inc r9
    cmp r9, r8
    jb .letter
    mov rdi, r13
    mov rsi, output_buffer
    mov rdx, r10
    call write_all
    jmp .read
.close:
    mov eax, 3
    mov rdi, r12
    syscall
    test rax, rax
    js error
    mov eax, 3
    mov rdi, r13
    syscall
    test rax, rax
    js error
    jmp finish

include 'io.inc'
