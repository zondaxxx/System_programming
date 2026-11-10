format ELF
public _start
msg db "Рулев", 0xA, "Константин", 0xA, "Александрович", 0xA, 0

_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 59
    int 0x80


    mov eax, 1
    mov ebx, 0
    int 0x80
