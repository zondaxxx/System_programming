; Лабораторная работа №2. Задание 4. Вариант 16.
; Для заданного числа N найти сумму его цифр и вывести результат на экран.
format ELF64
public _start

section '.data' writable
  number dq 2710058798            ; заданное число N
  msg    db "Sum of digits of 2710058798 = "
  msg_len = $ - msg
  place  db ?                     ; байт для вывода одного символа

section '.text' executable
_start:
    mov rsi, msg
    mov rdx, msg_len
    call print

    ; считаем сумму цифр: делим число на 10, остаток - очередная цифра
    mov rax, [number]
    mov rcx, 10
    xor rbx, rbx                  ; rbx - накопитель суммы
  .digits:
    xor rdx, rdx
    div rcx                       ; rax = rax / 10, rdx = rax mod 10
    add rbx, rdx
    test rax, rax
    jnz .digits

    ; выводим сумму: цифры кладем в стек, затем печатаем в обратном порядке
    mov rax, rbx
    xor rbx, rbx                  ; rbx - количество цифр
  .push:
    xor rdx, rdx
    div rcx
    add rdx, '0'                  ; цифра -> символ
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

; вывод одного символа из al
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
    mov eax, 1                    ; sys_exit
    mov ebx, 0
    int 0x80
