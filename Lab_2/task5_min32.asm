format ELF executable 3
entry start

segment readable executable
start:
    mov eax, 2710058798
    mov ecx, 10
    xor ebx, ebx
  .digits:
    xor edx, edx
    div ecx
    add ebx, edx
    test eax, eax
    jnz .digits

    sub esp, 16
    mov eax, ebx
    lea esi, [esp + 15]
    mov byte [esi], 0xA
  .conv:
    xor edx, edx
    div ecx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .conv

    lea edx, [esp + 16]
    sub edx, esi
    mov ecx, esi
    mov ebx, 1
    mov eax, 4
    int 0x80
    mov eax, 1
    xor ebx, ebx
    int 0x80
