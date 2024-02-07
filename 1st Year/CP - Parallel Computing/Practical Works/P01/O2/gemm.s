	.file	"gemm.c"
	.text
	.p2align 4,,15
	.globl	gemm1
	.type	gemm1, @function
gemm1:
.LFB11:
	.cfi_startproc
	testl	%ecx, %ecx
	jle	.L10
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leal	-1(%rcx), %eax
	movslq	%ecx, %r9
	movq	%rdx, %r13
	salq	$2, %r9
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	leaq	4(,%rax,4), %rdi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%ebx, %ebx
.L3:
	leaq	0(%r13,%rbx), %rdx
	leaq	(%r12,%rbx), %r10
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L7:
	leaq	(%rsi,%r11), %r8
	movss	(%rdx), %xmm1
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L5:
	movss	(%r10,%rax,4), %xmm0
	addq	$1, %rax
	mulss	(%r8), %xmm0
	addq	%r9, %r8
	cmpl	%eax, %ecx
	addss	%xmm0, %xmm1
	jg	.L5
	addq	$4, %r11
	movss	%xmm1, (%rdx)
	addq	$4, %rdx
	cmpq	%rdi, %r11
	jne	.L7
	addl	$1, %ebp
	addq	%r9, %rbx
	cmpl	%ecx, %ebp
	jne	.L3
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_restore 13
	.cfi_def_cfa_offset 8
.L10:
	rep ret
	.cfi_endproc
.LFE11:
	.size	gemm1, .-gemm1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"gemm2() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm2
	.type	gemm2, @function
gemm2:
.LFB12:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC0, %edi
	jmp	fwrite
	.cfi_endproc
.LFE12:
	.size	gemm2, .-gemm2
	.section	.rodata.str1.1
.LC1:
	.string	"gemm3() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm3
	.type	gemm3, @function
gemm3:
.LFB13:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC1, %edi
	jmp	fwrite
	.cfi_endproc
.LFE13:
	.size	gemm3, .-gemm3
	.section	.rodata.str1.1
.LC2:
	.string	"gemm4() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm4
	.type	gemm4, @function
gemm4:
.LFB14:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC2, %edi
	jmp	fwrite
	.cfi_endproc
.LFE14:
	.size	gemm4, .-gemm4
	.section	.rodata.str1.1
.LC3:
	.string	"gemm5() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm5
	.type	gemm5, @function
gemm5:
.LFB15:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC3, %edi
	jmp	fwrite
	.cfi_endproc
.LFE15:
	.size	gemm5, .-gemm5
	.section	.rodata.str1.1
.LC4:
	.string	"gemm6() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm6
	.type	gemm6, @function
gemm6:
.LFB16:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC4, %edi
	jmp	fwrite
	.cfi_endproc
.LFE16:
	.size	gemm6, .-gemm6
	.section	.rodata.str1.1
.LC5:
	.string	"gemm7() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm7
	.type	gemm7, @function
gemm7:
.LFB17:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC5, %edi
	jmp	fwrite
	.cfi_endproc
.LFE17:
	.size	gemm7, .-gemm7
	.section	.rodata.str1.1
.LC6:
	.string	"gemm8() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm8
	.type	gemm8, @function
gemm8:
.LFB18:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC6, %edi
	jmp	fwrite
	.cfi_endproc
.LFE18:
	.size	gemm8, .-gemm8
	.section	.rodata.str1.1
.LC7:
	.string	"gemm9() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm9
	.type	gemm9, @function
gemm9:
.LFB19:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC7, %edi
	jmp	fwrite
	.cfi_endproc
.LFE19:
	.size	gemm9, .-gemm9
	.section	.rodata.str1.1
.LC8:
	.string	"gemm10() not supported!\n\n"
	.text
	.p2align 4,,15
	.globl	gemm10
	.type	gemm10, @function
gemm10:
.LFB20:
	.cfi_startproc
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	movl	$.LC8, %edi
	jmp	fwrite
	.cfi_endproc
.LFE20:
	.size	gemm10, .-gemm10
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits
