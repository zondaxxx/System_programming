; Лабораторная работа №2. Задание 1. Вариант 16.
; Вывести заданную строку S в обратном порядке.
format ELF64
public _start

section '.data' writable
  msg1  db "S          = "
  msg1_len = $ - msg1
  msg2  db "S reversed = "
  msg2_len = $ - msg2
  S     db "TTaQgEqQJZdfGgqazcJpCDzwNgDdwpM"
  S_len = $ - S                 ; длину строки вычисляет ассемблер
  nl    db 0xA                  ; перевод строки сразу за S

section '.text' executable
_start:
    ; выводим исходную строку
    mov rsi, msg1
    mov rdx, msg1_len
    call print
    mov rsi, S
    mov rdx, S_len + 1            ; строка вместе с переводом строки
    call print

    ; переворачиваем строку прямо в памяти:
    ; rsi - указатель на левый край, rdi - на правый край
    mov rsi, S
    mov rdi, S + S_len - 1
  .swap:
    cmp rsi, rdi                  ; указатели встретились - готово
    jae .done
    mov al, [rsi]                 ; меняем местами два байта
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp .swap
  .done:

    ; выводим перевернутую строку
    mov rsi, msg2
    mov rdx, msg2_len
    call print
    mov rsi, S
    mov rdx, S_len + 1
    call print
    call exit

section '.print' executable
; вывод на экран rdx байт, начиная с адреса rsi
print:
    push rax
    push rbx
    push rcx
    mov eax, 4                    ; sys_write
    mov ebx, 1                    ; stdout
    mov ecx, esi                  ; адрес данных
    int 0x80
    pop rcx
    pop rbx
    pop rax
    ret

section '.exit' executable
exit:
    mov eax, 1                    ; sys_exit
    mov ebx, 0
    int 0x80
