format ELF64
public _start

section '.bss' writable
input_buffer rb 4096
output_buffer rb 256
present rb 256

section '.text' executable
_start:
    cmp qword [rsp], 4
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
    xor esi, esi
    syscall
    test rax, rax
    js error
    mov r13, rax
    mov eax, 2
    mov rdi, [rsp + 32]
    mov esi, 193
    mov edx, 644o
    syscall
    test rax, rax
    js error
    mov r14, rax
.read_second:
    xor eax, eax
    mov rdi, r13
    mov rsi, input_buffer
    mov edx, 4096
    syscall
    cmp rax, -4
    je .read_second
    test rax, rax
    js error
    jz .read_first
    mov r8, rax
    xor r9d, r9d
.mark:
    movzx ebx, byte [input_buffer + r9]
    mov byte [present + rbx], 1
    inc r9
    cmp r9, r8
    jb .mark
    jmp .read_second
.read_first:
    xor eax, eax
    mov rdi, r12
    mov rsi, input_buffer
    mov edx, 4096
    syscall
    cmp rax, -4
    je .read_first
    test rax, rax
    js error
    jz .close
    mov r8, rax
    xor r9d, r9d
    xor r10d, r10d
.select:
    movzx ebx, byte [input_buffer + r9]
    cmp byte [present + rbx], 0
    je .next
    mov [output_buffer + r10], bl
    inc r10
    mov byte [present + rbx], 0
.next:
    inc r9
    cmp r9, r8
    jb .select
    mov rdi, r14
    mov rsi, output_buffer
    mov rdx, r10
    call write_all
    jmp .read_first
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
    mov eax, 3
    mov rdi, r14
    syscall
    test rax, rax
    js error
    jmp finish

include 'io.inc'
