; hello.asm
; NASM x64 program to capture and display register values
; It first saves register values into memory, then prints the saved copies.

default rel
global main
extern printf

section .data
    fmt db "%-4s = 0x%016llX", 10, 0

    name_rax db "RAX", 0
    name_rbx db "RBX", 0
    name_rcx db "RCX", 0
    name_rdx db "RDX", 0
    name_rsi db "RSI", 0
    name_rdi db "RDI", 0
    name_rbp db "RBP", 0
    name_rsp db "RSP", 0
    name_r8  db "R8",  0
    name_r9  db "R9",  0
    name_r10 db "R10", 0
    name_r11 db "R11", 0
    name_r12 db "R12", 0
    name_r13 db "R13", 0
    name_r14 db "R14", 0
    name_r15 db "R15", 0

    reg_table:
        dq name_rax, save_rax
        dq name_rbx, save_rbx
        dq name_rcx, save_rcx
        dq name_rdx, save_rdx
        dq name_rsi, save_rsi
        dq name_rdi, save_rdi
        dq name_rbp, save_rbp
        dq name_rsp, save_rsp
        dq name_r8,  save_r8
        dq name_r9,  save_r9
        dq name_r10, save_r10
        dq name_r11, save_r11
        dq name_r12, save_r12
        dq name_r13, save_r13
        dq name_r14, save_r14
        dq name_r15, save_r15

    reg_count equ 16

section .bss
    save_rax resq 1
    save_rbx resq 1
    save_rcx resq 1
    save_rdx resq 1
    save_rsi resq 1
    save_rdi resq 1
    save_rbp resq 1
    save_rsp resq 1
    save_r8  resq 1
    save_r9  resq 1
    save_r10 resq 1
    save_r11 resq 1
    save_r12 resq 1
    save_r13 resq 1
    save_r14 resq 1
    save_r15 resq 1

section .text

main:
    ; ------------------------------------------------
    ; STEP 1: Save current register values into memory
    ; ------------------------------------------------
    ; These MOV instructions copy values from registers
    ; into memory. They do not modify the source registers.

    mov [save_rax], rax
    mov [save_rbx], rbx
    mov [save_rcx], rcx
    mov [save_rdx], rdx
    mov [save_rsi], rsi
    mov [save_rdi], rdi
    mov [save_rbp], rbp
    mov [save_rsp], rsp
    mov [save_r8],  r8
    mov [save_r9],  r9
    mov [save_r10], r10
    mov [save_r11], r11
    mov [save_r12], r12
    mov [save_r13], r13
    mov [save_r14], r14
    mov [save_r15], r15

    ; ------------------------------------------------
    ; STEP 2: Preserve non-volatile registers
    ; ------------------------------------------------
    ; We will use some registers for printing,
    ; so we save them first.

    push rbx
    push rbp
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15

    ; Windows x64 calling convention requires stack space
    ; before calling printf.

    sub rsp, 40

    ; ------------------------------------------------
    ; STEP 3: Print saved register values
    ; ------------------------------------------------

    lea rbx, [reg_table]
    mov rdi, reg_count

print_loop:
    mov rdx, [rbx]        ; register name
    mov r10, [rbx + 8]    ; address of saved value
    mov r8,  [r10]        ; saved register value

    lea rcx, [fmt]        ; printf format
    call printf

    add rbx, 16           ; move to next table entry
    dec rdi
    jnz print_loop

    ; ------------------------------------------------
    ; STEP 4: Restore stack and registers
    ; ------------------------------------------------

    add rsp, 40

    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbp
    pop rbx

    xor eax, eax
    ret