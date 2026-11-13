format ELF64 executable 3
entry start

segment readable executable
start:
    mov rax, 2710058798
    mov ecx, 10
    xor ebx, ebx
  .digits:
    xor edx, edx
    div rcx
    add ebx, edx
    test rax, rax
    jnz .digits

    mov eax, ebx
    lea rsi, [rsp - 1]
    mov byte [rsi], 0xA
  .conv:
    xor edx, edx
    div ecx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test eax, eax
    jnz .conv

    mov rdx, rsp
    sub rdx, rsi
    mov edi, 1
    mov eax, 1
    syscall
    mov eax, 60
    xor edi, edi
    syscall
