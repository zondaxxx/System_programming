format ELF64
public _start

section '.data' writable
  number dq 2710058798
  msg    db "Sum of digits of 2710058798 = "
  msg_len = $ - msg
  place  db ?

section '.text' executable
_start:
    mov rsi, msg
    mov rdx, msg_len
    call print

    mov rax, [number]
    mov rcx, 10
    xor rbx, rbx
  .digits:
    xor rdx, rdx
    div rcx
    add rbx, rdx
    test rax, rax
    jnz .digits

    mov rax, rbx
    xor rbx, rbx
  .push:
    xor rdx, rdx
    div rcx
    add rdx, '0'
    push rdx
    inc rbx
    test rax, rax
    jnz .push
  .pop:
    pop rax
    call print_symb
    dec rbx
    jnz .pop
    mov rax, 0xA
    call print_symb
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

print_symb:
    push rbx
    push rcx
    push rdx
    push rax
    mov [place], al
    mov eax, 4
    mov ebx, 1
    mov ecx, place
    mov edx, 1
    int 0x80
    pop rax
    pop rdx
    pop rcx
    pop rbx
    ret

section '.exit' executable
exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
