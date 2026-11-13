format ELF64
public _start

N = 300
D = ';'

section '.bss' writable
  buf db N dup (?)

section '.data' writable
  nl db 0xA

section '.text' executable
_start:

    mov rdi, buf
    mov rcx, N
    mov al, D
  .fill:
    mov [rdi], al
    inc rdi
    dec rcx
    jnz .fill

    mov rsi, buf
    mov rcx, 1
  .row:
    mov rdx, rcx
    call print
    call newline
    add rsi, rcx
    inc rcx
    cmp rsi, buf + N
    jb .row
    call exit

section '.print' executable

print:
    push rax
    push rbx
    push rcx
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    pop rcx
    pop rbx
    pop rax
    ret

newline:
    push rsi
    push rdx
    mov rsi, nl
    mov rdx, 1
    call print
    pop rdx
    pop rsi
    ret

section '.exit' executable
exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
