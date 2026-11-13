format ELF64
public _start

extrn initscr
extrn start_color
extrn init_pair
extrn noecho
extrn cbreak
extrn stdscr
extrn getmaxx
extrn getmaxy
extrn clear
extrn move
extrn addch
extrn refresh
extrn timeout
extrn getch
extrn endwin
extrn exit

section '.data' writable
    width dd 0
    height dd 0
    new_width dd 0
    x dd 0
    y dd 0
    direction dd 0
    length dd 1
    remaining dd 1
    turns dd 0
    palette dd 100h
    delay dd 80
    step_x dd 0, 1, 0, -1
    step_y dd -1, 0, 1, 0

section '.text' executable
_start:
    call initscr
    test rax, rax
    jz failed
    call start_color
    cmp eax, -1
    je screen_failed
    mov edi, 1
    mov esi, 7
    xor edx, edx
    call init_pair
    cmp eax, -1
    je screen_failed
    mov edi, 2
    mov esi, 3
    xor edx, edx
    call init_pair
    cmp eax, -1
    je screen_failed
    call noecho
    call cbreak

draw:
    mov rdi, [stdscr]
    call getmaxx
    dec eax
    mov [new_width], eax
    mov rdi, [stdscr]
    call getmaxy
    cmp eax, 1
    jl screen_failed
    cmp dword [new_width], 1
    jl screen_failed
    cmp eax, [height]
    jne resized
    mov edx, [new_width]
    cmp edx, [width]
    je paint
resized:
    mov [height], eax
    mov eax, [new_width]
    mov [width], eax
    call clear
    call reset
paint:
    mov edi, [y]
    mov esi, [x]
    call move
    mov edi, [palette]
    or edi, '#'
    call addch
    mov edi, [y]
    mov esi, [x]
    call move
    call refresh
    mov edi, [delay]
    call timeout
    call getch
    cmp eax, 'p'
    je done
    cmp eax, 'f'
    jne advance
    shr dword [delay], 1
    cmp dword [delay], 20
    jge advance
    mov dword [delay], 160
advance:
    mov ecx, [direction]
    mov eax, [x]
    add eax, [step_x + rcx * 4]
    mov edx, [y]
    add edx, [step_y + rcx * 4]
    cmp eax, 0
    jl again
    cmp eax, [width]
    jge again
    cmp edx, 0
    jl again
    cmp edx, [height]
    jge again
    mov [x], eax
    mov [y], edx
    dec dword [remaining]
    jnz draw
    inc dword [direction]
    and dword [direction], 3
    inc dword [turns]
    cmp dword [turns], 2
    jne next_side
    mov dword [turns], 0
    inc dword [length]
next_side:
    mov eax, [length]
    mov [remaining], eax
    jmp draw
again:
    xor dword [palette], 300h
    call reset
    jmp draw

reset:
    mov eax, [width]
    dec eax
    shr eax, 1
    mov [x], eax
    mov eax, [height]
    shr eax, 1
    mov [y], eax
    mov dword [direction], 0
    mov dword [length], 1
    mov dword [remaining], 1
    mov dword [turns], 0
    ret

done:
    call endwin
    xor edi, edi
    call exit
screen_failed:
    call endwin
failed:
    mov edi, 1
    call exit
