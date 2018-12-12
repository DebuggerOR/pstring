# 318732484 Ori Fogler
# those are the functions therselfs

	.section 	.rodata			# read only section

str_format:		.string "%s" 	# string format
invalid_msg: 	.string "invalid input!\n"

	.text						# code section
.globl 	pstrlen
	.type 	pstrlen, @function

# the input is pointer to pstring and the output is the length of the pstring (it's stored before the string)

pstrlen: 						# pstrlen function
	
	xor 	%rax, %rax 			# make %rax 0 
	movb 	(%rdi), %al 		# return value the length of the string
	
	ret 						# end of pstrlen


.globl 	replaceChar
	.type 	replaceChar, @function

# the input is pointer to pstring and 2 chars, and the output is string that the first char replaced by the second

replaceChar: 					# replaceChar function
	
	movq 	%rdi, %r9 			# later pass the chars by the register

.while_replace: 				# do while
	
	leaq 	1(%r9), %r9 		# get the next char of the string
	cmpb 	(%r9), %sil 		# if old char  == char of pstring
	je 		.true_replace 		# jump to true replace
	jmp 	.finish_replace		# jump to finish replace

.true_replace:
	
	movb 	%dl, (%r9) 			# replacing the old char with the new char

.finish_replace: 								

	cmpb 	$0, (%r9) 			# if char != '\0'
	jne 	.while_replace 		# go to the beginning of the loop
	movq 	%rdi, %rax 			# return value in %rax 
	
	ret 						# end of replaceChar


.globl pstrijcpy
	.type pstrijcpy, @function

# this function dets src pointer and dst pointer and indexes, and copies substring from src to dst according to indexes

pstrijcpy: 						# pstrijcpy function
	
	xorq 	%r8, %r8 			# init register to 0
	movq 	$52, %r8 			# keep in mind that the option is 52

.check_input:
	
	cmpb 	%dl, (%rsi) 		# check if index (i) is bigger than length
	jle 	.invalid_copy 		# jump to invalid
	
	cmpb 	%dl, (%rdi) 		# check if index (i) is bigger than length
	jle 	.invalid_copy 		# jump to invalid
	
	cmpb 	%cl, (%rsi) 		# check if index (j) is bigger than length
	jle 	.invalid_copy 		# jump to invalid
	
	cmpb 	%cl, (%rdi) 		# check if index (j) is bigger than length
	jle 	.invalid_copy 		# jump to invalid
	
	cmpq 	$54, %r8 			# case option is 54
	je 		.valid_input 		# continue in pstrijcmp function

	leaq 	1(%rdi), %r9 		# point start of dst
	leaq 	1(%rsi), %r10 		# point start of src
	addq 	%rdx, %r9 			# point dst at i
	addq 	%rdx, %r10 			# point src at i

.while_copy:
	
	cmpb 	%cl, %dl 			# index i is bigger than index j
	jg 		.finish_copy 		# nothing more to do
	
	xorq 	%r11, %r11 			# init register by 0
	movb 	(%r10), %r11b 		# move char of src at i
	movb 	%r11b, (%r9) 		# move it to dst
	incq 	%r10	 			# add 1 to src pointer
	incq 	%r9 				# add 1 to dst pointer
	incb 	%dl 				# add 1 to index i
	
	jmp 	.while_copy 		# continue loop

.invalid_copy:
	
	pushq 	%r8 				# save register that says if its 52 or 54 option
	pushq 	%rdi 				# save pointer to pstr1
	
	movq 	$str_format, %rdi 	# str format is the first argument for printf
	movq	$invalid_msg, %rsi  # invalid msg is the second argument for printf
	xorq 	%rax, %rax			# make %rax 0 for printf and scanf
	call 	printf 				# print invalid input
	
	popq 	%rdi 				# get the saved value
	popq 	%r8 				# get the saved value
	
	cmpq 	$54, %r8 			# check if its option 54
	je 		.invalid_compare	# return to option 54

.finish_copy:
	
	movq 	%rdi, %rax 			# return value, in %rax, pointer to first pstring
	
	ret 						# end of pstrijcpy


	.globl swapCase
.type swapCase, @function

#replace the upper case letters by lower case and the opposite

swapCase: 						# swapCase function
	
	movq 	%rdi, %r9 			# start of pstring in order to iterate in loop

.while_swap:
	
	cmpb 	$65,(%r9)			# 65 is 'A' in ascii
	jge 	.ifGreater65		# > 65
	
	jmp 	.finish_swap		# < 65

.ifGreater65:
	
	cmpb 	$90, (%r9)			# 90 is 'Z' in ascii
	jle 	.isUpperCase		# < 90 (and > 65)
	
	cmpb 	$97, (%r9)			# 97 is 'a' in ascii
	jge 	.ifGreater97				# > 97
	
	jmp 	.finish_swap

.ifGreater97:
	
	cmpb 	$122, (%r9)			# 122 is 'z' in ascii
	jle 	.isLowerCase		# < 122 (and > 97)
	
	jmp 	.finish_swap

.isLowerCase:
	
	subb 	$32, (%r9)			# case it is lower sub 32 (97 - 65) to make upper
	jmp 	.finish_swap

.isUpperCase:
	
	addb 	$32, (%r9)			# case it is upper add 32 (97 - 65) to make lower

.finish_swap:
	
	incq 	%r9		 			# add one to register to advance chars
	cmpb 	$0, (%r9) 			# check if '\0'
	jne 	.while_swap 		# while not '\0' continue loop	
	
	movq 	%rdi, %rax			# return value
	
	ret 						# end of swapCase


	.globl pstrijcmp
.type pstrijcmp, @function

# this function compares between tow substrings with indexes

pstrijcmp: 						# pstrijcmp function
	
	xorq 	%r8, %r8 			# make register 0
	movq 	$54, %r8 			# keep in mind that the option is 54
	jmp 	.check_input 		# use code of option 52 to check the input

.valid_input:
	
	leaq 	1(%rdi), %r9 		# start of pstr1 to iterate over the string
	leaq 	1(%rsi), %r10 		# start of pstr2 to iterate over the string
	addq 	%rdx, %r9 			# point pstring1[i]
	addq 	%rdx, %r10 			# point pstring2[i] 

	xorq 	%r8, %r8 			# init register by 0

.while_compare:
	
	cmpb 	%cl, %dl 			# if index i > index j
	jg 		.equals_compare 	# strings equal
	
	movb 	(%r10), %r8b 		# mov pstring2[i]
	cmpb 	(%r9), %r8b 		# if letter of pstr2 > letter of str2
	jg 		.pstr2_greater 		# jump to str2 greater
	
	cmpb 	(%r9), %r8b  		# if letter pstring[i] < first pstring[i]
	jl 		.pstr2_lower		# jump to pstr2 lower
	
	incq 	%r9 				# add 1 to pstring1
	incq 	%r10	 			# add 1 to pstring2
	incb 	%dl 				# add 1 to index i
	jmp 	.while_compare 		# loop in while

.pstr2_greater:
	
	xorq 	%rax, %rax			# init register to 0
	movq 	$-1, %rax 			# assign return value -1
	jmp 	.return_compare		# jump to end	

.pstr2_lower:
	
	xorq 	%rax, %rax			# init register to 0
	movq 	$1, %rax 			# make return value 1
	jmp 	.return_compare 	# jump to end

.equals_compare:
	
	xorq 	%rax, %rax 			# make return value 0 (equal)
	jmp 	.return_compare 	# jump to end

.invalid_compare:
	
	xorq 	%rax, %rax 			# make register 0
	movq 	$-2, %rax 			# make return value -2 (invalid)

.return_compare:
	
	ret 						# end
