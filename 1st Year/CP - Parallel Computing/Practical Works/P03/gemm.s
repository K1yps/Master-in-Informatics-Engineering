	.file	"gemm.c"
	.text
	.p2align 4,,15
	.globl	gemm1
	.type	gemm1, @function
gemm1:
.LFB11:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	testl	%ecx, %ecx
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	movq	%rsi, %rdi
	movl	%ecx, %esi
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	jle	.L1
	leal	-1(%rcx), %eax
	movslq	%ecx, %r9
	movq	%rdx, %r13
	salq	$2, %r9
	xorl	%r12d, %r12d
	xorl	%r14d, %r14d
	leaq	4(,%rax,4), %rbx
	.p2align 4,,10
	.p2align 3
.L3:
	leaq	0(%r13,%r12), %rcx
	leaq	0(%rbp,%r12), %r10
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L7:
	leaq	(%rdi,%rdx), %r8
	movss	(%r10), %xmm0
	leal	-1(%rsi), %r11d
	movl	$1, %eax
	mulss	(%r8), %xmm0
	addq	%r9, %r8
	andl	$7, %r11d
	cmpl	$1, %esi
	addss	(%rcx), %xmm0
	jle	.L4
	testl	%r11d, %r11d
	je	.L5
	cmpl	$1, %r11d
	je	.L29
	cmpl	$2, %r11d
	je	.L30
	cmpl	$3, %r11d
	je	.L31
	cmpl	$4, %r11d
	je	.L32
	cmpl	$5, %r11d
	je	.L33
	cmpl	$6, %r11d
	je	.L34
	movss	4(%r10), %xmm1
	movl	$2, %eax
	mulss	(%r8), %xmm1
	addq	%r9, %r8
	addss	%xmm1, %xmm0
.L34:
	movss	(%r10,%rax,4), %xmm2
	addq	$1, %rax
	mulss	(%r8), %xmm2
	addq	%r9, %r8
	addss	%xmm2, %xmm0
.L33:
	movss	(%r10,%rax,4), %xmm3
	addq	$1, %rax
	mulss	(%r8), %xmm3
	addq	%r9, %r8
	addss	%xmm3, %xmm0
.L32:
	movss	(%r10,%rax,4), %xmm4
	addq	$1, %rax
	mulss	(%r8), %xmm4
	addq	%r9, %r8
	addss	%xmm4, %xmm0
.L31:
	movss	(%r10,%rax,4), %xmm5
	addq	$1, %rax
	mulss	(%r8), %xmm5
	addq	%r9, %r8
	addss	%xmm5, %xmm0
.L30:
	movss	(%r10,%rax,4), %xmm6
	addq	$1, %rax
	mulss	(%r8), %xmm6
	addq	%r9, %r8
	addss	%xmm6, %xmm0
.L29:
	movss	(%r10,%rax,4), %xmm7
	addq	$1, %rax
	mulss	(%r8), %xmm7
	addq	%r9, %r8
	cmpl	%eax, %esi
	addss	%xmm7, %xmm0
	jle	.L4
.L5:
	movss	(%r10,%rax,4), %xmm8
	mulss	(%r8), %xmm8
	movss	4(%r10,%rax,4), %xmm9
	addq	%r9, %r8
	movss	8(%r10,%rax,4), %xmm10
	mulss	(%r8), %xmm9
	addq	%r9, %r8
	mulss	(%r8), %xmm10
	movss	12(%r10,%rax,4), %xmm11
	addq	%r9, %r8
	movss	16(%r10,%rax,4), %xmm12
	mulss	(%r8), %xmm11
	addq	%r9, %r8
	addss	%xmm8, %xmm0
	mulss	(%r8), %xmm12
	addq	%r9, %r8
	movss	20(%r10,%rax,4), %xmm13
	mulss	(%r8), %xmm13
	movss	24(%r10,%rax,4), %xmm14
	addq	%r9, %r8
	movss	28(%r10,%rax,4), %xmm15
	addss	%xmm9, %xmm0
	mulss	(%r8), %xmm14
	addq	%r9, %r8
	mulss	(%r8), %xmm15
	addq	$8, %rax
	addq	%r9, %r8
	cmpl	%eax, %esi
	addss	%xmm10, %xmm0
	addss	%xmm11, %xmm0
	addss	%xmm12, %xmm0
	addss	%xmm13, %xmm0
	addss	%xmm14, %xmm0
	addss	%xmm15, %xmm0
	jg	.L5
.L4:
	addq	$4, %rdx
	movss	%xmm0, (%rcx)
	addq	$4, %rcx
	cmpq	%rbx, %rdx
	jne	.L7
	addl	$1, %r14d
	addq	%r9, %r12
	cmpl	%esi, %r14d
	jne	.L3
.L1:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE11:
	.size	gemm1, .-gemm1
	.p2align 4,,15
	.globl	gemm2
	.type	gemm2, @function
gemm2:
.LFB12:
	.cfi_startproc
	testl	%ecx, %ecx
	jle	.L89
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movq	%rdx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	movslq	%ecx, %rsi
	salq	$2, %rsi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	xorl	%edi, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L47:
	leaq	0(%r13,%rdi), %r11
	leaq	0(%rbp,%rdi), %r9
	movq	%r12, %r8
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L51:
	movss	(%r9), %xmm0
	leal	-1(%rcx), %r10d
	movl	$1, %eax
	mulss	(%r8), %xmm0
	andl	$7, %r10d
	cmpl	$1, %ecx
	addss	(%r11), %xmm0
	jle	.L48
	testl	%r10d, %r10d
	je	.L49
	cmpl	$1, %r10d
	je	.L73
	cmpl	$2, %r10d
	je	.L74
	cmpl	$3, %r10d
	je	.L75
	cmpl	$4, %r10d
	je	.L76
	cmpl	$5, %r10d
	je	.L77
	cmpl	$6, %r10d
	je	.L78
	movss	4(%r9), %xmm1
	movl	$2, %eax
	mulss	4(%r8), %xmm1
	addss	%xmm1, %xmm0
.L78:
	movss	(%r9,%rax,4), %xmm2
	mulss	(%r8,%rax,4), %xmm2
	addq	$1, %rax
	addss	%xmm2, %xmm0
.L77:
	movss	(%r9,%rax,4), %xmm3
	mulss	(%r8,%rax,4), %xmm3
	addq	$1, %rax
	addss	%xmm3, %xmm0
.L76:
	movss	(%r9,%rax,4), %xmm4
	mulss	(%r8,%rax,4), %xmm4
	addq	$1, %rax
	addss	%xmm4, %xmm0
.L75:
	movss	(%r9,%rax,4), %xmm5
	mulss	(%r8,%rax,4), %xmm5
	addq	$1, %rax
	addss	%xmm5, %xmm0
.L74:
	movss	(%r9,%rax,4), %xmm6
	mulss	(%r8,%rax,4), %xmm6
	addq	$1, %rax
	addss	%xmm6, %xmm0
.L73:
	movss	(%r9,%rax,4), %xmm7
	mulss	(%r8,%rax,4), %xmm7
	addq	$1, %rax
	cmpl	%eax, %ecx
	addss	%xmm7, %xmm0
	jle	.L48
.L49:
	movss	(%r9,%rax,4), %xmm8
	mulss	(%r8,%rax,4), %xmm8
	movss	4(%r9,%rax,4), %xmm9
	mulss	4(%r8,%rax,4), %xmm9
	movss	8(%r9,%rax,4), %xmm10
	mulss	8(%r8,%rax,4), %xmm10
	movss	12(%r9,%rax,4), %xmm11
	mulss	12(%r8,%rax,4), %xmm11
	movss	16(%r9,%rax,4), %xmm12
	mulss	16(%r8,%rax,4), %xmm12
	movss	20(%r9,%rax,4), %xmm13
	mulss	20(%r8,%rax,4), %xmm13
	movss	24(%r9,%rax,4), %xmm14
	addss	%xmm8, %xmm0
	mulss	24(%r8,%rax,4), %xmm14
	movss	28(%r9,%rax,4), %xmm15
	mulss	28(%r8,%rax,4), %xmm15
	addq	$8, %rax
	cmpl	%eax, %ecx
	addss	%xmm9, %xmm0
	addss	%xmm10, %xmm0
	addss	%xmm11, %xmm0
	addss	%xmm12, %xmm0
	addss	%xmm13, %xmm0
	addss	%xmm14, %xmm0
	addss	%xmm15, %xmm0
	jg	.L49
.L48:
	addl	$1, %edx
	movss	%xmm0, (%r11)
	addq	%rsi, %r8
	addq	$4, %r11
	cmpl	%ecx, %edx
	jne	.L51
	addl	$1, %ebx
	addq	%rsi, %rdi
	cmpl	%ecx, %ebx
	jne	.L47
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
.L89:
	rep ret
	.cfi_endproc
.LFE12:
	.size	gemm2, .-gemm2
	.p2align 4,,15
	.globl	gemm3
	.type	gemm3, @function
gemm3:
.LFB13:
	.cfi_startproc
	testl	%ecx, %ecx
	jle	.L113
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	%ecx, %eax
	movq	%rdi, %r15
	subq	%rdx, %r15
	sall	$5, %eax
	movslq	%ecx, %r9
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	cltq
	salq	$2, %r9
	salq	$2, %rax
	xorl	%r14d, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	leaq	-128(%r15), %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	leaq	128(%rdx), %r12
	subq	%rdi, %rdx
	leaq	(%rsi,%rdx), %rdx
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	leal	-1(%rcx), %ebx
	shrl	$5, %ebx
	movq	%rax, -40(%rsp)
	subq	$-128, %rax
	salq	$7, %rbx
	movq	%rax, -56(%rsp)
	movq	%rdx, -8(%rsp)
	subq	%rbx, %r13
	subq	$-128, %rbx
	movq	%r13, %rbp
	movq	%rbx, -16(%rsp)
	movq	%r15, %r13
.L92:
	movq	-8(%rsp), %rbx
	movq	%r13, %r10
	movq	%r12, %r15
	movl	%r14d, %r13d
	movq	%r12, %r14
	movq	%r10, %r12
.L102:
	movq	-16(%rsp), %rdi
	movq	%r10, %r11
	addq	%r10, %rdi
	movq	%rdi, -48(%rsp)
.L101:
	leaq	-128(%r11), %rax
	leaq	(%r11,%rbx), %rdx
	movq	%r15, %r8
	movl	$32, -60(%rsp)
	movq	%rax, -32(%rsp)
	movq	%rdx, -24(%rsp)
.L99:
	movq	-32(%rsp), %rsi
	movq	-24(%rsp), %rdx
	leaq	-128(%r8), %rdi
	leaq	(%rsi,%r8), %rsi
	.p2align 4,,10
	.p2align 3
.L97:
	movss	(%rdi), %xmm0
	xorl	%eax, %eax
.L94:
	movss	(%rsi,%rax), %xmm1
	mulss	(%rdx,%rax), %xmm1
	movss	4(%rax,%rsi), %xmm2
	mulss	4(%rdx,%rax), %xmm2
	movss	8(%rax,%rsi), %xmm3
	mulss	8(%rdx,%rax), %xmm3
	movss	12(%rax,%rsi), %xmm4
	mulss	12(%rdx,%rax), %xmm4
	movss	16(%rax,%rsi), %xmm5
	mulss	16(%rdx,%rax), %xmm5
	movss	20(%rax,%rsi), %xmm6
	mulss	20(%rdx,%rax), %xmm6
	movss	24(%rax,%rsi), %xmm7
	addss	%xmm1, %xmm0
	mulss	24(%rdx,%rax), %xmm7
	movss	28(%rax,%rsi), %xmm8
	mulss	28(%rdx,%rax), %xmm8
	addq	$32, %rax
	cmpq	$128, %rax
	addss	%xmm2, %xmm0
	addss	%xmm3, %xmm0
	addss	%xmm4, %xmm0
	addss	%xmm5, %xmm0
	addss	%xmm6, %xmm0
	addss	%xmm7, %xmm0
	addss	%xmm8, %xmm0
	jne	.L94
	movss	%xmm0, (%rdi)
	addq	$4, %rdi
	addq	%r9, %rdx
	cmpq	%r8, %rdi
	jne	.L97
	subl	$1, -60(%rsp)
	leaq	(%rdi,%r9), %r8
	jne	.L99
	subq	$-128, %r11
	cmpq	-48(%rsp), %r11
	jne	.L101
	addq	$-128, %r10
	subq	$-128, %r15
	addq	-56(%rsp), %rbx
	cmpq	%rbp, %r10
	jne	.L102
	movq	%r12, %rbx
	movq	%r14, %r12
	movl	%r13d, %r14d
	addl	$32, %r14d
	addq	-40(%rsp), %r12
	movq	%rbx, %r13
	cmpl	%r14d, %ecx
	jg	.L92
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_restore 13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_restore 14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_restore 15
	.cfi_def_cfa_offset 8
.L113:
	ret
	.cfi_endproc
.LFE13:
	.size	gemm3, .-gemm3
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
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
	movl	$.LC0, %edi
	jmp	fwrite
	.cfi_endproc
.LFE14:
	.size	gemm4, .-gemm4
	.section	.rodata.str1.1
.LC1:
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
	movl	$.LC1, %edi
	jmp	fwrite
	.cfi_endproc
.LFE15:
	.size	gemm5, .-gemm5
	.section	.rodata.str1.1
.LC2:
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
	movl	$.LC2, %edi
	jmp	fwrite
	.cfi_endproc
.LFE16:
	.size	gemm6, .-gemm6
	.section	.rodata.str1.1
.LC3:
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
	movl	$.LC3, %edi
	jmp	fwrite
	.cfi_endproc
.LFE17:
	.size	gemm7, .-gemm7
	.section	.rodata.str1.1
.LC4:
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
	movl	$.LC4, %edi
	jmp	fwrite
	.cfi_endproc
.LFE18:
	.size	gemm8, .-gemm8
	.section	.rodata.str1.1
.LC5:
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
	movl	$.LC5, %edi
	jmp	fwrite
	.cfi_endproc
.LFE19:
	.size	gemm9, .-gemm9
	.section	.rodata.str1.1
.LC6:
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
	movl	$.LC6, %edi
	jmp	fwrite
	.cfi_endproc
.LFE20:
	.size	gemm10, .-gemm10
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits
