section .bss
    valueToPrint resb 1
    inputBuffer  resb 16
    number1 resw 1 ; 16 bits
    number2 resw 1 ; 16 bits
    number3 resw 1 ; 16 bits
    result resw 1

section .data
    prompt db "Ingrese un numero: ", 0
    len_prompt equ $ - prompt

section .text
    global _start

_start:
    ; Leer primer número
    mov ecx, prompt
    mov edx, len_prompt
    call print_string

    call read_number
    mov [number1], ax

    ; Leer segundo número
    mov ecx, prompt
    mov edx, len_prompt
    call print_string

    call read_number
    mov [number2], ax

    ; Leer tercer número
    mov ecx, prompt
    mov edx, len_prompt
    call print_string

    call read_number
    mov [number3], ax

    ; Restar los valores
    mov ax, [number1] ; cargar el primer numero en ax
    sub ax, [number2] ; restar el segundo numero
    sub ax, [number3] ; restar el tercer numero

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

    ; convertir ASCII a binario
    mov ecx, eax
    mov esi, inputBuffer
    xor eax, eax
    xor ebx, ebx

.read_loop:
    lodsb
    cmp al, 10  ; comprobar si es una nueva línea (enter)
    je .done
    sub al, '0'
    imul ebx, eax, 10
    add eax, ebx
    loop .read_loop

.done:
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

endl: ; salto de línea
    mov eax, 10
    call print_char
    ret

print_char: ; imprimir un carácter
    mov [valueToPrint], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, valueToPrint
    mov edx, 1
    int 0x80
    ret
