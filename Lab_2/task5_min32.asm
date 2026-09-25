; Лабораторная работа №2. Задание 5. Вариант 16.
; Минимизированная 32-битная версия: заголовки ELF32 короче, чем у ELF64,
; число 2710058798 < 2^32 и помещается в 32-битный регистр.
format ELF executable 3
entry start

segment readable executable
start:
    mov eax, 2710058798           ; заданное число N
    mov ecx, 10
    xor ebx, ebx                  ; ebx - сумма цифр
  .digits:
    xor edx, edx
    div ecx
    add ebx, edx
    test eax, eax
    jnz .digits

    ; переводим сумму в строку в буфере на стеке
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

    lea edx, [esp + 16]           ; длина строки = esp + 16 - esi
    sub edx, esi
    mov ecx, esi
    mov ebx, 1                    ; stdout
    mov eax, 4                    ; sys_write
    int 0x80
    mov eax, 1                    ; sys_exit
    xor ebx, ebx
    int 0x80
