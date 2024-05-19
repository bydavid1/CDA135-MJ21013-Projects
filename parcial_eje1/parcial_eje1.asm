section .data
    cadena1 db 51 ; cadena 1 50 caracteres + 1 para el nulo
    cadena2 db 51 ; cadena 2 50 caracteres + 1 para el nulo
    mensajeingreso1 db "Ingrese la primera cadena: ", 0
    mensajeingreso1len equ $-mensajeingreso1
    mensajeingreso2 db "Ingrese la segunda cadena: ", 0
    mensajeingreso2len equ $-mensajeingreso2
    mensajeresultado1 db "La primera cadena es mas larga", 0
    mensajeresultado2 db "La segunda cadena es mas larga", 0

section .text
    global _start

_start:
  ; imprimir el primer mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, mensajeingreso1
    mov edx, mensajeingreso1len
    int 0x80

  ; capturar la primera cadena
    mov eax, 3
    mov ebx, 0
    mov ecx, cadena1
    mov edx, 50
    int 0x80

  ; imprimir el segundo mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, mensajeingreso2
    mov edx, mensajeingreso2len
    int 0x80

  ; capturar la segunda cadena
    mov eax, 3
    mov ebx, 0
    mov ecx, cadena2
    mov edx, 50
    int 0x80

    ; calcular la longitud de cadena 1
    mov esi, cadena1
    call obtener_longitud
    mov ebx, eax ; guardar el len de cadena 1 en ebx

    ; calcular la longitud de cadena 2
    mov esi, cadena2
    call obtener_longitud
    mov ecx, eax ; guardar el len de cadena 2 en ecx

    ; hacer la comparación de las longitudes
    cmp ebx, ecx ; NO PUDE HACER QUE ME FUNCIONARA LA COMPARACION :(
    jl cadena2_mas_larga ; si cadena 2 es mas grande
    jg cadena1_mas_larga ; si cadena 1 es mas grande

cadena1_mas_larga:
    ; mostrar mensaje de que la primera cadena es mas larga
    mov eax, 4
    mov ebx, 1
    mov ecx, mensajeresultado1
    mov edx, 31
    int 0x80
    jmp fin_programa

cadena2_mas_larga:
    ; mostrar mensaje de que la segunda cadena es mas larga
    mov eax, 4
    mov ebx, 1
    mov ecx, mensajeresultado2
    mov edx, 31
    int 0x80
    jmp fin_programa

obtener_longitud: ; funcion para calcular la longitud de la cadena
    xor eax, eax ; eax = 0
    xor ecx, ecx ; contador de longitud = 0

calcular_longitud:
    cmp byte [esi + ecx], 0 ; verifica si el caracter actual es nulo
    je fin_calculo ; si es verdadero terminar
    inc ecx  ; incrementar el contador
    jmp calcular_longitud ; seguir buscando

fin_calculo:
    mov eax, ecx ; eax = longitud de la cadena
    ret

fin_programa: ; salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80
