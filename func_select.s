# 318732484 Ori Fogler
# here it is run_func that handles user's choice by switch case

	.section 	.rodata			# read only section

int_format:		.string "%d"	# int format
chr_format:		.string "\n%c"	# char format
str_format:		.string "%s" 	# string format

default_msg: 	.string "invalid option!\n"
case50_msg:		.string "first pstring length: %d, second pstring length: %d\n"
case51_msg: 	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
case5253_msg:	.string "length: %d, string: %s\n"
case54_msg:  	.string "compare result: %d\n"

.switch:						# jump table for the switch case
	
	.quad 	.case50 			# char pstrlen(Pstring* pstr)
	.quad 	.case51 			# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
	.quad 	.case52 			# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
	.quad 	.case53 			# Pstring* swapCase(Pstring* pstr)
	.quad 	.case54 			# int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)

	.text 						# code section
.globl run_func
	.type run_func, @function

run_func: 						# run function
	
	leaq 	-50(%rdi), %rbx 	# make user's valid input between 0 and 4
	cmpq 	$4, %rbx 			# check if input fits range
	ja 		.default 			# case no, jump to default
	jmp 	*.switch(,%rbx,8) 	# else, jump to the correct case of the switch

.case50:						# option 50 char pstrlen(Pstring* pstr)
	
	movq 	%rsi, %rdi 			# pstr1 is the argument for pstrlen
	call 	pstrlen 			# return the length of the str
	
	movq 	%rax, %r8 			# keep return value

	movq 	%rdx, %rdi 			# pstr2 is the argument for pstrlen
	call 	pstrlen 			# return the length of the str
	
	movq	$case50_msg, %rdi	# case 50 msg is the first msg to printf
	movq 	%r8, %rsi 			# return value 1 is the second arg to printf
	movq 	%rax, %rdx 			# return value 2 is the third arg to printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf 				# print the lengthes of the strings
	
	jmp 	.return 			# jump to the end

.case51:
	
	movq 	%rsi, %r14 			# save pointer to first str
	movq 	%rdx, %r15 			# save pointer to second str

	leaq 	-1(%rsp), %rsp 		# get a byte for char

	movq 	$chr_format, %rdi 	# char format is the first arg to scanf
	movq 	%rsp, %rsi 			# pointer to the end of the stack is the second arg to printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	scanf 				# input first char

	leaq 	-1(%rsp), %rsp 		# get a byte for char

	movq 	$chr_format, %rdi 	# char format is the first arg to scanf
	movq 	%rsp, %rsi 			# pointer to the end of the stack is the second arg to printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	scanf 				# input second char

	movq 	%r14, %rdi 			# pointer to string1 is the first argument for replaceChar
	xorq 	%rdx, %rdx 			# assign zero to third argument of replaceChar(new char)
	movb 	(%rsp), %dl 		# take third argument from stack
	leaq 	1(%rsp), %rsp 		# delete from stack new char
	xorq 	%rsi, %rsi 			# assign zero to second argument(old char)
	movb 	(%rsp), %sil		# take second argument from stack
	leaq 	1(%rsp), %rsp 		# delete from stack old char
	call 	replaceChar 		# replace old char by new char
	
	movq 	%rax, %r14 			# keep the returned value

	movq 	%r15, %rdi 			# set first argument to replaceChar(pointer to second pstring)
	call 	replaceChar 		# replace old char by new char (other args are the same as before)
	
	movq 	%rax, %r15 			# keep the returned value

	movq 	$case51_msg, %rdi	# case 51 is the first argument for printf
	leaq 	1(%r14), %rcx 		# pointer to pstr1 is the forth argument to printf (2 and 3 like before)
	leaq 	1(%r15), %r8 		# pointer to pstr2 is the fifth argument to printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call	printf 				# print case 51 msg
	
	jmp 	.return 			# jump to the end

.case52:
	
	xorq 	%rbx, %rbx          # make register 0
	movq 	$52, %rbx 			# put 52 in register to know option 52 chosen

.input_52_54:
	
	movq 	%rsi, %r14 			# keep pointer to first string
	movq 	%rdx, %r15 			# keep pointer to second string

	subq 	$4, %rsp 			# get 4 bytes for first index

	movq 	$int_format, %rdi 	# int format is the first argument for scanf
	movq 	%rsp, %rsi 			# pointer to the end of the stack is the second arg
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	scanf 				# input the first index
	
	movl 	(%rsp), %r12d 		# keep first index

	movq 	$int_format, %rdi 	# int format is the first argument for scanf
	movq 	%rsp, %rsi 			# pointer to the end of the stack is the second arg
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	scanf 				# input the second index
	
	movl 	(%rsp), %r13d 		# keep second index

	addq 	$4, %rsp 			# release 4 bytes

	movq 	%r14, %rdi 			# pstr1 is the first argument 
	movq 	%r15, %rsi 			# second argument to pstrijcpy the second pstring
	xorq 	%rdx, %rdx 			# make register 0
	movb 	%r12b, %dl 			# third argument to pstrijcpy the first index
	xorq 	%rcx, %rcx 			# make register 0
	movb 	%r13b, %cl 			# fourth argument to pstrijcpy the second index)

	cmpq 	$54, %rbx 			# check if it's case 54 input

	je 		.callPstrijcmp 		# jump to case 54

	call	pstrijcpy 			# else - call pstrijcpy to copy substrings
	
	movq 	%rax, %r14 			# save return value

.printing52_53:
	
	movq 	$case5253_msg, %rdi # case 52 53 msg is the first argument to printf
	xorq 	%rsi, %rsi 			# make register 0
	movb 	(%r14), %sil 		# set second argument to printf
	leaq 	1(%r14), %rdx 		# set third argument to printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf 				# print in case 52 format

	movq 	$case5253_msg, %rdi # case 52 53 msg is the first argument for printf
	xorq 	%rsi, %rsi 			# make register 0
	movb 	(%r15), %sil 		# second argument for printf
	leaq 	1(%r15), %rdx 		# third argument for printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf 				# print case 52 53 format
	
	jmp 	.return 			# jump to the end

.case53:
	
	movq 	%rsi, %r14 			# save pointer to pstr1
	movq 	%rdx, %r15 			# save pointer to str2

	movq 	%r14, %rdi 			# pstring1 is the argument for swapCase
	call 	swapCase 			# replace the old char by the new char
	
	movq 	%rax, %r14 			# save return value

	movq 	%r15, %rdi 			# pstring2 is the argument for swapCase
	call 	swapCase 			# replace the old char by the new char
	
	movq 	%rax, %r15 			# save return value
	jmp 	.printing52_53 		# print like the print in case 53

.case54:
	
	xorq 	%rbx, %rbx          # make the register 0
	movq 	$54, %rbx 			# keep in mind that this 54 option chosen
	jmp 	.input_52_54  		# get input as in option 52

.callPstrijcmp:

	call 	pstrijcmp 			# compare sub strings option

	movq 	%rax, %rsi 			# the returned value is the first argument for printf
	movq 	$case54_msg, %rdi 	# case 54 msg is the second argument for printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf 				# print case 54 msg
	
	jmp 	.return 			# jump to the end

.default:
	
	movq 	$str_format, %rdi	# str format is the first arg for printf
	movq	$default_msg, %rsi	# default msg is the second arg for printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf				# print default msg
	
	jmp 	.return 			# jump to the end

.return: 						
	
	ret
