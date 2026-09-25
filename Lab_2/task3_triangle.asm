; Лабораторная работа №2. Задание 3. Вариант 16.
; Заполнить память N заданными символами и вывести их в виде треугольника:
; в первой строке 1 символ, во второй 2 и т.д., пока не выведены все N символов.
format ELF64
public _start

N = 300                           ; количество символов (1+2+...+24 = 300)
D = ';'                           ; заданный символ

section '.bss' writable
  buf db N dup (?)

section '.data' writable
  nl db 0xA

section '.text' executable
_start:
    ; заполняем память N символами D
    mov rdi, buf
    mov rcx, N
    mov al, D
  .fill:
    mov [rdi], al
    inc rdi
    dec rcx
    jnz .fill

    ; выводим треугольник
    mov rsi, buf                  ; текущая позиция в памяти
    mov rcx, 1                    ; длина текущей строки
  .row:
    mov rdx, rcx
    call print                    ; rcx символов из памяти
    call newline
    add rsi, rcx                  ; сдвигаем позицию на выведенное количество
    inc rcx                       ; следующая строка длиннее на 1
    cmp rsi, buf + N              ; пока не выведены все N символов
    jb .row
    call exit

section '.print' executable
; вывод на экран rdx байт, начиная с адреса rsi
print:
    push rax
    push rbx
    push rcx
    mov eax, 4                    ; sys_write
    mov ebx, 1                    ; stdout
    mov ecx, esi
    int 0x80
    pop rcx
    pop rbx
    pop rax
    ret

; вывод перевода строки
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
    mov eax, 1                    ; sys_exit
    mov ebx, 0
    int 0x80
