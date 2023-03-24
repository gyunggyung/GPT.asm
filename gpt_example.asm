section .data
input_vector dd 2.0, 3.0, 4.0, 5.0
input1 dd 2.0, 3.0
input2 dd 4.0, 5.0
weights dd 1.0, 0.5

section .bss
dot_product resd 1
attention_score resd 1
result resd 2

section .text
global _start

_start:
    ; Calculate Self-Attention score
    mov eax, [input_vector]
    mov ebx, [input_vector+4]
    mov ecx, [input_vector+8]
    mov edx, [input_vector+12]

    fld dword [eax]
    fmul dword [ebx]
    fld dword [ecx]
    fmul dword [edx]
    faddp st1, st0
    fstp dword [dot_product]

    fld dword [dot_product]
    fldl2e
    fmulp st1, st0
    frndint
    fxch st1
    fsub st0, st1
    f2xm1
    fld1
    faddp st1, st0
    fstp dword [attention_score]

    ; Calculate Residual Connection and Feed Forward
    movups xmm0, [input1]
    movups xmm1, [input2]
    movups xmm2, [weights]

    addps xmm0, xmm1
    mulps xmm1, xmm2
    addps xmm0, xmm1
    movups [result], xmm0

    ; Exit system call
    mov eax, 1
    xor edi, edi
    syscall
