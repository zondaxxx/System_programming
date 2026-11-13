section '.data' writable
    error_text db 'Invalid input', 10
    error_length = $ - error_text

section '.bss' writable
    input_byte rb 1
    output_buffer rb 32

section '.text' executable
read_number:
    xor r8, r8
    xor r9, r9
.read:
    xor eax, eax
    xor edi, edi
    mov rsi, input_byte
    mov edx, 1
    syscall
    test rax, rax
    js invalid_input
    jz .done
    movzx eax, byte [input_byte]
    cmp al, 10
    je .done
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    sub eax, '0'
    imul r8, 10
    add r8, rax
    cmp r8, r10
    ja invalid_input
    inc r9
    jmp .read
.done:
    test r9, r9
    jz invalid_input
    mov rax, r8
    ret

print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r11
    mov rsi, output_buffer + 31
    mov byte [rsi], 10
    mov ecx, 1
    mov ebx, 10
.digit:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .digit
    mov rdx, rcx
    mov eax, 1
    mov edi, 1
    syscall
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

finish:
    mov eax, 60
    xor edi, edi
    syscall

invalid_input:
    mov eax, 1
    mov edi, 2
    mov rsi, error_text
    mov edx, error_length
    syscall
    mov eax, 60
    mov edi, 1
    syscall
