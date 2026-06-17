; hello.asm
; Basic NASM x64 program
; This program adds multiple numbers and stores the result

default rel
global main

section .data
    num1 dq 10
    num2 dq 20
    num3 dq 30
    num4 dq 40

    result dq 0

section .text

main:
    ; Load first number into RAX register
    mov rax, [num1]

    ; Add other numbers
    add rax, [num2]
    add rax, [num3]
    add rax, [num4]

    ; Store final answer in memory
    mov [result], rax

    ; Return result as program exit code
    ; 10 + 20 + 30 + 40 = 100
    ret