format ELF64
public _start

section '.data' writable
  msg1  db "S          = "
  msg1_len = $ - msg1
  msg2  db "S reversed = "
  msg2_len = $ - msg2
  S     db "TTaQgEqQJZdfGgqazcJpCDzwNgDdwpM"
  S_len = $ - S
  nl    db 0xA

section '.text' executable
_start:

    mov rsi, msg1
    mov rdx, msg1_len
    call print
    mov rsi, S
    mov rdx, S_len + 1
    call print

    mov rsi, S
    mov rdi, S + S_len - 1
  .swap:
    cmp rsi, rdi
    jae .done
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp .swap
  .done:

    mov rsi, msg2
    mov rdx, msg2_len
    call print
    mov rsi, S
    mov rdx, S_len + 1
    call print
    call exit

section '.print' executable

print:
    push rax
    push rbx
    push rcx
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    pop rcx
    pop rbx
    pop rax
    ret

section '.exit' executable
exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
