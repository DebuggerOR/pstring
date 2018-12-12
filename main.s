# 318732484 Ori Fogler
# this is the main of ex3

	.section	.rodata			# read only section
int_format:		.string "%d"	# int format
str_format:		.string "%s" 	# string format

	.text 						# code section
.globl main 					
	.type main, @function 		

main:							# main function

	pushq	%rbp 				# keep old frame pointer in the stack
	movq	%rsp, %rbp 			# init new frame pointer

	leaq 	-4(%rsp), %rsp 		# get 4 bytes of the stack for the length
	
	movq 	$int_format, %rdi 	# int format is the first argument for scanf
	movq	%rsp, %rsi 			# pointer to the end of the stack is the second argument
	xorq 	%rax, %rax			# make %rax zero for printf and scanf
	call 	scanf 				# input the length of the string

	xorq	%r9, %r9 			# make register zero
	movb 	(%rsp), %r9b 		# the length of the string is in the last byte of the register
	leaq 	2(%rsp), %rsp 		# 2 bytes at the end for the '\0' and the length
 	subq 	%r9, %rsp 			# more place, the length of the string, on the stack for the string
	movb 	%r9b, (%rsp) 		# the length at the end of the stack
	
	movq 	$str_format, %rdi 	# str format is the first argument to scan
	leaq 	1(%rsp), %rsi 		# pointer to the end of the stack (-1) is the second argument
	xorq 	%rax, %rax			# make %rax zero for printf and scanf
	call 	scanf 				# input string by the user
	
	movq 	%rsp, %r14 			# set a pointer to the string

	leaq 	-4(%rsp), %rsp 		# get 4 bytes of the stack for the length
	
	movq 	$int_format, %rdi 	# int format is the first argument for scanf
	movq	%rsp, %rsi 			# pointer to the end of the stack is the second argument
	xorq 	%rax, %rax			# make %rax zero for printf and scanf
	call 	scanf 				# input the length of the string

	xorq 	%r8, %r8 			# make register zero
	movb 	(%rsp), %r8b 		# get the input value as byte from the last bytes of the number
	leaq 	2(%rsp), %rsp 		# free 2 bytes and save one for the '\0' and one in the begining for the size
 	subq 	%r8, %rsp 			# allocate the size of the string in the stack
	movb 	%r8b, (%rsp) 		# push the size to the begining of the pstring(currently end of stack)
	
	movq 	$str_format, %rdi 	# string format is the first argument to scanf
	leaq 	1(%rsp), %rsi 		# pointer to the end of the stack (-1) is the second argument
	xorq 	%rax, %rax			# make %rax zero for printf and scanf
	call 	scanf 				# input string by the user
	
	movq 	%rsp, %r13 			# set a pointer to the string
	
	leaq 	-4(%rsp), %rsp 		# get 4 bytes of the stack for the length
	
	movq 	$int_format, %rdi 	# int format is the first argument to scanf
	movq	%rsp, %rsi 			# pointer to the end of the stack is the second argument
	xorq 	%rax, %rax			# make %rax zero for printf and scanf
	call 	scanf 				# input choice from user

	movl 	(%rsp), %edi 		# user's input is the first argument for run_func
	movq 	%r14, %rsi 			# pointer to pstr1 is the second argument for run_func
	movq 	%r13, %rdx 			# pointer to pstr2 is the third argument for run_func
	call 	run_func 			# call run_func that calls func according to input

	xorq 	%rax, %rax			# %rax the return value should be 0
	movq 	%rbp, %rsp 			# restore the old pointer of the stack
	popq	%rbp 				# restore old frame pointer (the caller function frame)
	
	ret 		
					