section '.data' writable
error_message db 'Error: invalid input', 10
error_length = $ - error_message

section '.bss' writable
number_buffer rb 32

section '.text' executable
parse_number:
    xor rax, rax
    mov r8, 1
    cmp byte [rsi], '-'
    jne .plus
    mov r8, -1
    inc rsi
    jmp .first
.plus:
    cmp byte [rsi], '+'
    jne .first
    inc rsi
.first:
    cmp byte [rsi], 0
    je error
.digit:
    xor r9, r9
    mov r9b, [rsi]
    cmp r9b, '0'
    jb error
    cmp r9b, '9'
    ja error
    sub r9, '0'
    imul rax, 10
    add rax, r9
    cmp rax, 1000000000
    ja error
    inc rsi
    cmp byte [rsi], 0
    jne .digit
    imul rax, r8
    ret

print_number:
    mov rsi, number_buffer + 31
    mov byte [rsi], 10
    mov r8, rax
    cmp rax, 0
    jge .digits
    neg rax
.digits:
    mov r9, 10
.next:
    xor rdx, rdx
    div r9
    add dl, '0'
    dec rsi
    mov [rsi], dl
    cmp rax, 0
    jne .next
    cmp r8, 0
    jge .write
    dec rsi
    mov byte [rsi], '-'
.write:
    mov rdx, number_buffer + 32
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

error:
    mov rax, 1
    mov rdi, 2
    mov rsi, error_message
    mov rdx, error_length
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
