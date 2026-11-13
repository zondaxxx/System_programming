section '.text' executable

write_all:
    test rdx, rdx
    jz .done
.next:
    mov eax, 1
    syscall
    cmp rax, -4
    je .next
    test rax, rax
    jle error
    add rsi, rax
    sub rdx, rax
    jnz .next
.done:
    ret

error:
    mov eax, 1
    mov edi, 2
    mov rsi, error_text
    mov edx, error_length
    syscall
    mov eax, 60
    mov edi, 1
    syscall

finish:
    mov eax, 60
    xor edi, edi
    syscall

section '.data' writable
error_text db 'Error: check arguments, input files and a NEW output filename.', 10
error_length = $ - error_text
