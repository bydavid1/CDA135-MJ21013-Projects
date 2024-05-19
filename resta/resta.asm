section .data
    mensaje1 db "El primer numero es: ", 0xA, 0
    msglen1 equ $-mensaje1

    mensaje2 db "El segundo numero es: ", 0xA, 0
    msglen2 equ $-mensaje2

section .bss
    buffer resb 12

section .text
    global main

main:
    ; imprimir el primer mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje1
    mov edx, msglen1
    int 0x80

    ; imprimir el primer numero
    mov eax, 12345
    mov edi, buffer
    call int_to_string
    mov ecx, edi
    call print_string

    ; imprimir el segundo mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje2
    mov edx, msglen2
    int 0x80

    ; imprimir el segundo numero
    mov eax, -6789
    mov edi, buffer
    call int_to_string
    mov ecx, edi
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 0x80

int_to_string:
    mov ecx, 10
    xor edx, edx
    mov ebx, 0

    test eax, eax
    jns .convert
    neg eax
    mov byte [edi+ebx], '-'
    inc ebx

.convert:
    lea esi, [edi+ebx]
    mov edi, esi
    add edi, 11
    mov byte [edi], 0

.conv_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .conv_loop

    mov edi, esi
    ret

print_string:
    mov edx, 0
.find_len:
    cmp byte [ecx+edx], 0
    je .found_len
    inc edx
    jmp .find_len

.found_len:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
