; Лабораторная работа №2. Задание 2. Вариант 16.
; Заполнить память N заданными символами и вывести их
; в виде матрицы по M символов в строке, K строк.
format ELF64
public _start

N = 300                           ; количество символов
M = 12                            ; символов в строке
K = 25                            ; количество строк
D = ';'                           ; заданный символ

section '.bss' writable
  buf db N dup (?)                ; область памяти под N символов

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

    ; выводим K строк по M символов
    mov rsi, buf                  ; текущая позиция в памяти
    mov rcx, K                    ; счетчик строк
  .row:
    mov rdx, M
    call print                    ; M символов текущей строки
    call newline
    add rsi, M                    ; переходим к следующей порции памяти
    dec rcx
    jnz .row
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
