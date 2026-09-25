; Лабораторная работа №2. Задание 5. Вариант 16.
; Минимизированная 64-битная версия: fasm сам формирует исполняемый ELF
; (без секций, без линковщика), буфер для строки - в стеке (red zone),
; поэтому используется 64-битный системный вызов syscall.
format ELF64 executable 3
entry start

segment readable executable
start:
    mov rax, 2710058798           ; заданное число N
    mov ecx, 10
    xor ebx, ebx                  ; ebx - сумма цифр
  .digits:
    xor edx, edx
    div rcx
    add ebx, edx
    test rax, rax
    jnz .digits

    ; переводим сумму в строку, заполняя буфер с конца
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

    mov rdx, rsp                  ; длина строки = rsp - rsi
    sub rdx, rsi
    mov edi, 1                    ; stdout
    mov eax, 1                    ; sys_write (64-битный ABI)
    syscall
    mov eax, 60                   ; sys_exit
    xor edi, edi
    syscall
