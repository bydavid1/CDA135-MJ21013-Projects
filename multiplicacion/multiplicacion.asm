section .bss
    valueToPrint resb 1
    inputBuffer  resb 16
    number1 resb 1 ; 8 bits
    number2 resb 1 ; 8 bits
    result resw 1

section .data
    prompt db "Ingrese un numero del 0 a 255: ", 0
    len_prompt equ $ - prompt

section .text
    global _start

_start:
    ; Leer primer número
    mov ecx, prompt
    mov edx, len_prompt
    call print_string

    call read_number
    mov [number1], al

    ; Leer segundo número
    mov ecx, prompt
    mov edx, len_prompt
    call print_string

    call read_number
    mov [number2], al

    ; Multiplicar los valores
    mov al, [number1] ; cargar el primer numero en al
    mov bl, [number2] ; cargar el segundo numero en bl
    mul bl ; multiplicar al * bl, resultado en ax

    mov [result], ax

    ; Convertir el valor a ASCII y mostrarlo
    mov eax, [result]
    call convert_values
    call endl

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_string:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

read_number:
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 16
    int 0x80

    ; Convertir ASCII a binario
    mov ecx, eax
    mov esi, inputBuffer
    xor eax, eax
    xor ebx, ebx

.read_loop:
    movzx edx, byte [esi]
    sub edx, '0' ; convertir ASCII a valor numerico
    imul eax, eax, 10
    add eax, edx
    inc esi
    loop .read_loop ; repetir
    ret

convert_values:
    mov edx, 0
    mov ecx, 0x0A
    idiv ecx 
    push eax
    mov eax, edx
    add eax, '0'
    call print_char
    pop eax
    or eax, eax
    jnz convert_values

endl: ; salto de linea
    mov eax, 10
    call print_char
    ret

print_char: ; imprimir un caracter
    mov [valueToPrint], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, valueToPrint
    mov edx, 1
    int 0x80
    ret
