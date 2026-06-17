section .text
    global _start

_start:
    ; 1. Initialize values into x86_64 registers (equivalent to t1 and t2)
    mov rbx, 5          ; rbx acts like $t1
    mov rcx, 10         ; rcx acts like $t2

    ; 2. Add them together into rax (rax acts like $t0)
    mov rax, rbx        ; copy rbx into rax
    add rax, rcx        ; rax = rax + rcx (5 + 10 = 15)

    ; 3. Safely exit the program using Linux system calls
    mov rax, 60         ; 60 is the sys_exit system call number
    mov rdi, 0          ; return code 0 (success).
    syscall
