section .data
    buffer resb 6 ; almacenar 5 digitos + 1 para el nulo
    mensaje db "Ingrese un numero: ", 0
    mensaje_len equ $-mensaje
    salto_linea db 10

section .text
    global _start

_start:
    ; pedir el numero
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje
    mov edx, mensaje_len
    int 0x80

    ; leer numero
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 6
    int 0x80

    ; imprimiir
    mov esi, buffer 

imprimir_digitos:
    movzx eax, byte [esi]  ; cargar el digito en eax
    test al, al ; verificar si es el ultimo digito
    jz fin_programa ; si lo es terminar

    ; imprimir digito
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, 1
    int 0x80

    ; imprimir el salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, salto_linea
    mov edx, 1
    int 0x80

    ; seguir al siguiente digito
    inc esi

    ; repetir
    jmp imprimir_digitos

fin_programa:
    mov eax, 1
    xor ebx, ebx
    int 0x80
