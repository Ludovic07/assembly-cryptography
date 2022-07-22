.data
mycypher: 			.string 	"ABDCDBCEAE"
					.zero		10
myplaintext:      	.string     "AMO AssEMbLY" 
					.zero		10
cypthertext:		.zero		1000
					.zero		10
occctext:			.zero		1000
					.zero		10
filteredtext:		.zero		100
					.zero		10
ntotbuff:			.zero		10
					.zero		10
blocKey:      		.string     "OLE" 
					.zero		10
k:					.word   	1
newline:  			.byte		10

.text
functionCall:
	la a0, cypthertext
	sw a0, -12(sp)
	la a0, myplaintext
	sw a0, -8(sp)
	li a0, 0
	sw a0, -4(sp)			#i = 0
mstrcpy:
	lw a5, -4(sp)
	lw a4, -8(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = myplaintext[i]

	lw a5, -4(sp)
	lw a4, -12(sp)
	add a5, a4, a5
	sb a6, 0(a5)			#cypthertext[i] = a6

	blez a6, exitmstrcpy	#if temp <= 0 jump

	lw a0, -4(sp)
	addi a0, a0, 1
	sw a0, -4(sp)			#i = i+1
	j mstrcpy
	
exitmstrcpy:
	la a0, myplaintext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline

encryption_call:
	addi sp, sp, -4
	li a0, 0
	sw a0, 0(sp)			#i = 0
encryption_loop:
	la a5, mycypher
	lw a4, 0(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = mycypher[i]
	blez a6, exit_en_loop
	addi a3, a6, -65
	beqz a3, caseA
	addi a3, a6, -66
	beqz a3, caseB
	addi a3, a6, -67
	beqz a3, caseC
	addi a3, a6, -68
	beqz a3, caseD
	addi a3, a6, -69
	beqz a3, caseE
	j exit_en_loop			#if iillegal char then exit encryption
caseA:
	la a0, cypthertext
	la a1, cypthertext
	lw a2, k
	jal Substitution_Cipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j en_loop_inc
caseB:
	la a0, cypthertext
	la a1, blocKey
	la a2, cypthertext
	jal Block_Cipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j en_loop_inc
caseC:
	la a0, cypthertext
	la a1, occctext
	la a2, filteredtext
	la a3, ntotbuff
	jal Occurrence_Cipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j en_loop_inc
caseD:
	la a0, cypthertext
	la a1, cypthertext
	jal Dictionary_Cipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j en_loop_inc
caseE:
	la a0, cypthertext
	la a1, cypthertext
	jal Inversion_Cipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j en_loop_inc

en_loop_inc:
	lw a0, 0(sp)
	addi a0, a0, 1
	sw a0, 0(sp)			#i = i+1
	j encryption_loop		#jump encryption_loop

exit_en_loop:

#####################################################
decryption_call:
	lw a0, 0(sp)
	addi a0, a0, -1
	sw a0, 0(sp)			#i = i-1
decryption_loop:
	la a5, mycypher
	lw a4, 0(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = mycypher[i]
	blez a6, exit_de_loop
	addi a3, a6, -65
	beqz a3, DeCaseA
	addi a3, a6, -66
	beqz a3, DeCaseB
	addi a3, a6, -67
	beqz a3, DeCaseC
	addi a3, a6, -68
	beqz a3, DeCaseD
	addi a3, a6, -69
	beqz a3, DeCaseE
	j exit_de_loop			#if iillegal char then exit decryption
DeCaseA:
	la a0, cypthertext
	la a1, cypthertext
	lw a2, k
	jal Substitution_deCipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j de_loop_dec
DeCaseB:
	la a0, cypthertext
	la a1, blocKey
	la a2, cypthertext
	jal Block_deCipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j de_loop_dec
DeCaseC:
	la a0, cypthertext
	la a1, occctext
	jal  Occurrence_deCipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j de_loop_dec
DeCaseD:
	la a0, cypthertext
	la a1, cypthertext
	jal Dictionary_deCipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j de_loop_dec
DeCaseE:
	la a0, cypthertext
	la a1, cypthertext
	jal Inversion_deCipher
	la a0, cypthertext # Load the address of the string
    li a7, 4   # Argument '4' for ecall instructs ecall to print to console
    ecall
	jal printNewline	#print newline
	j de_loop_dec

de_loop_dec:
	lw a0, 0(sp)
	addi a0, a0, -1
	sw a0, 0(sp)			#i = i-1
	j decryption_loop		#jump decryption_loop

exit_de_loop:
	addi sp, sp, 4
	j exit

#######################################################		
Substitution_Cipher:
	addi sp, sp, -16
    sw ra, 12(sp) # return address
	#la a0, cypthertext
    sw a0, 8(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 4(sp)  # cypthertext address
	lw a2, k		
    sw a2, 0(sp)  # k
	
	li a6, 0 #i
subc_while:
	lw a0, 8(sp)	# load the address of cypthertext
	add a2, a0, a6	# cypthertext_address + i
	lb a7, 0(a2)	# Load character in a7
	beqz a7, subc_exit
	
	#if(temp >= 65 && temp <= 90)
    li a5, 64			
    ble a7, a5, subc_L1
    li a5, 90
    bgt a7, a5, subc_L1

	lw a2, 0(sp)  # k
    add a7, a7, a2			#temp = temp + k
    addi a7, a7, -65		#temp = temp - 65
	
	bgez a7, subc_LC1		#if temp positive then rem
	addi a7, a7, 26			#if negative add 26
	j subc_LC2
subc_LC1:
    li a5, 26
    rem a7, a7, a5			#temp = temp % 26
subc_LC2:
    addi a7, a7, 65			#temp = temp + 65
	j subc_L2

subc_L1:
	#if(temp >= 97 && temp <= 122)
    li a5, 96
	ble a7, a5, subc_L2
	li a5, 122
	bgt a7, a5, subc_L2

	lw a2, 0(sp)  #k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -97	#temp = temp - 97

	bgez a7, subc_LS1	#if temp positive then rem
	addi a7, a7, 26		#if negative add 26
	j subc_LS2
subc_LS1:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
subc_LS2:
    addi a7, a7, 97		#temp = temp + 97

subc_L2:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a6	# cypthertext_address + i
	sb a7, 0(a2)	# store character in a7
	addi a6, a6, 1	#i = i+1
	j subc_while
subc_exit:
	lw   ra, 12(sp) # Reload return address from stack
    addi sp, sp, 16 # Restore stack pointer
    ret


############################################
Substitution_deCipher:
	addi sp, sp, -16
    sw ra, 12(sp) # return address
	#la a0, cypthertext
    sw a0, 8(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 4(sp)  # cypthertext address
	#lw a2, k
	neg a2, a2		
    sw a2, 0(sp)  # k
	
	li a6, 0 #i
subdec_while:
	lw a0, 8(sp)	# load the address of cypthertext
	add a2, a0, a6	# cypthertext_address + i
	lb a7, 0(a2)	# Load character in a7
	beqz a7, subdec_exit
	
	#if(temp >= 65 && temp <= 90)
    li a5, 64			
    ble a7, a5, subdec_L1
    li a5, 90
    bgt a7, a5, subdec_L1

	lw a2, 0(sp)  # k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -65	#temp = temp - 65

	bgez a7, subdec_LC1		#if temp positive then rem
	addi a7, a7, 26			#if negative add 26
	j subdec_LC2
subdec_LC1:
    li a5, 26
    rem a7, a7, a5			#temp = temp % 26
subdec_LC2:
    addi a7, a7, 65			#temp = temp + 65
	j subdec_L2

subdec_L1:
	#if(temp >= 97 && temp <= 122)
    li a5, 96
	ble a7, a5, subdec_L2
	li a5, 122
	bgt a7, a5, subdec_L2

	lw a2, 0(sp)  # k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -97	#temp = temp - 97

	bgez a7, subdec_LS1	#if temp positive then rem
	addi a7, a7, 26		#if negative add 26
	j subdec_LS2
subdec_LS1:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
subdec_LS2:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
    addi a7, a7, 97		#temp = temp + 97

subdec_L2:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a6	# cypthertext_address + i
	sb a7, 0(a2)	# store character in a7
	addi a6, a6, 1	#i = i+1
	j subdec_while
subdec_exit:
	lw   ra, 12(sp) # Reload return address from stack
    addi sp, sp, 16 # Restore stack pointer
    ret
	
	
	
############################################		
Block_Cipher:
	addi sp, sp, -16
    sw ra, 12(sp) # return address
	#la a0, cypthertext
    sw a0, 8(sp)  # cypthertext address
	#la a1, blocKey
    sw a1, 4(sp)  # key address
	#la a2, cypthertext
    sw a2, 0(sp)  # cypthertext address

	li a7, 0 		#i
	li a6, 0 		#kptr
blkc_while:
	lw a0, 8(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, blkc_exit
	lw a0, 4(sp)	# load the address of key
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# Load character in a4
	bnez a4, blkc_L
	li a6, 0
blkc_L:
	lw a0, 4(sp)	# load the address of key
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# Load character in a4

	addi a5, a5, -32
	addi a4, a4, -32
	add a5, a5, a4
	li a2, 96
	rem a5, a5, a2
	addi a5, a5, 32
	lw a0, 0(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a5, 0(a2)	# Load character in a5

	addi a6, a6, 1
	addi a7, a7, 1
	j blkc_while
blkc_exit:
	lw   ra, 12(sp) # Reload return address from stack
    addi sp, sp, 16 # Restore stack pointer
    ret

############################################	
Block_deCipher:
	addi sp, sp, -16
    sw ra, 12(sp) # return address
	#la a0, cypthertext
    sw a0, 8(sp)  # cypthertext address
	#la a1, blocKey
    sw a1, 4(sp)  # key address
	#la a2, cypthertext
    sw a2, 0(sp)  # cypthertext address

	li a7, 0 		#i
	li a6, 0 		#kptr
blkdec_while:
	lw a0, 8(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, blkdec_exit
	lw a0, 4(sp)	# load the address of key
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# Load character in a4
	bnez a4, blkdec_L
	li a6, 0
blkdec_L:
	lw a0, 4(sp)	# load the address of key
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# Load character in a4
	addi a5, a5, 32
	neg a4, a4
	add a5, a5, a4
	li a2, 31
	bgt a5, a2, blkdec_L1
	addi a5, a5, 96
blkdec_L1:
    lw	a0, 0(sp)  # cypthertext address
	add a2, a0, a7
	sb a5, 0(a2)	# store character in a5
	addi a6, a6, 1
	addi a7, a7, 1
	j blkdec_while
blkdec_exit:
	lw   ra, 12(sp) # Reload return address from stack
    addi sp, sp, 16 # Restore stack pointer
    ret
	
	
############################################		
Dictionary_Cipher:
	addi sp, sp, -12
    sw ra, 8(sp) # return address
	#la a0, cypthertext
    sw a0, 4(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 0(sp)  # cypthertext address

	li a7, 0 		#i
dicc_while:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, dicc_exit	#if(itemp == 0) goto dicc_exit
dicc_L1:
	li a4, 64
	ble a5, a4, dicc_L2  #jump if input char in itemp(a5) =< 64
	li a4, 90
	bgt a5, a4, dicc_L2	 #jump if input char in itemp(a5) > 90

	mv a6, a5
	addi a6, a6, -65	 #temp(a6) = temp - 65
	neg a6, a6
	addi a6, a6, 25		 #temp  = 25 - temp
	addi a6, a6, 97		 #temp = temp + 97
	j dicc_L5			 #jump dicc_L5 to store the char

dicc_L2:
	li a4, 96
	ble a5, a4, dicc_L3		#jump if input char in itemp(a5) =< 96
	li a4, 122
	bgt a5, a4, dicc_L3		#jump if input char in itemp(a5) > 122

	mv a6, a5
	addi a6, a6, -97	#temp(a6) = temp - 97
	neg a6, a6
	addi a6, a6, 25		#temp  = 25 - temp
	addi a6, a6, 65		#temp = temp + 65
	j dicc_L5			#jump dicc_L5 to store the char

dicc_L3:
	li a4, 47
	ble a5, a4, dicc_L4		#jump if input char in itemp(a5) =< 47
	li a4, 57
	bgt a5, a4, dicc_L4		#jump if input char in itemp(a5) > 57

	mv a6, a5
	addi a6, a6, -48	#temp(a6) = temp - 48
	neg a6, a6
	addi a6, a6, 9		#temp  = 9 - temp
	addi a6, a6, 48		#temp = temp + 48
	j dicc_L5			#jump dicc_L5 to store the char

dicc_L4:
	mv a6, a5
dicc_L5:
	lw a0, 0(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a6, 0(a2)	# store character in a6
	addi a7, a7, 1	#i = i+1
	j dicc_while
dicc_exit:
	lw   ra, 8(sp) # Reload return address from stack
    addi sp, sp, 12 # Restore stack pointer
    ret

############################################	
Dictionary_deCipher:
	addi sp, sp, -12
    sw ra, 8(sp) # return address
	#la a0, cypthertext
    sw a0, 4(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 0(sp)  # cypthertext address

	li a7, 0 		#i
dicdec_while:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, dicdec_exit	#if(itemp == 0) goto dicc_exit
dicdec_L1:
	li a4, 64
	ble a5, a4, dicdec_L2	#jump if input char in itemp(a5) =< 64
	li a4, 90
	bgt a5, a4, dicdec_L2	#jump if input char in itemp(a5) > 90

	mv a6, a5
	addi a6, a6, -65		#temp(a6) = temp - 65
	neg a6, a6
	addi a6, a6, 25			#temp  = 25 - temp
	addi a6, a6, 97			#temp = temp + 97
	j dicdec_L5				#jump dicdec_L5 to store the char

dicdec_L2:
	li a4, 96
	ble a5, a4, dicdec_L3	#jump if input char in itemp(a5) =< 96
	li a4, 122
	bgt a5, a4, dicdec_L3	#jump if input char in itemp(a5) > 122

	mv a6, a5
	addi a6, a6, -97		#temp(a6) = temp - 97
	neg a6, a6
	addi a6, a6, 25			#temp  = 25 - temp
	addi a6, a6, 65			#temp = temp + 65
	j dicdec_L5				#jump dicdec_L5 to store the char

dicdec_L3:
	li a4, 47
	ble a5, a4, dicdec_L4	#jump if input char in itemp(a5) =< 47
	li a4, 57
	bgt a5, a4, dicdec_L4	##jump if input char in itemp(a5) > 57

	mv a6, a5
	addi a6, a6, -48		#temp(a6) = temp - 48
	neg a6, a6
	addi a6, a6, 9			#temp  = 9 - temp
	addi a6, a6, 48			#temp = temp + 48
	j dicdec_L5				#jump dicdec_L5 to store the char

dicdec_L4:
	mv a6, a5
dicdec_L5:
	lw a0, 0(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a6, 0(a2)	# store character in a6
	addi a7, a7, 1	#i = i+1
	j dicdec_while
dicdec_exit:
	lw   ra, 8(sp) # Reload return address from stack
    addi sp, sp, 12 # Restore stack pointer
    ret


############################################		
Inversion_Cipher:
	addi sp, sp, -12
    sw ra, 8(sp) # return address
	#la a0, cypthertext
    sw a0, 4(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 0(sp)  # cypthertext address
	
	li a7, 0 #i
invc_while:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, invc_L0
	addi a7, a7, 1	# i = i + 1
	j invc_while
invc_L0:
	mv a6, a7
	mv a5, a7
	srli a4, a5, 31
    add a5, a4, a5
    srai a5, a5, 1	#a5 = a5 / 2
	li a7, 0
invc_L1while:
	bgt a7, a5, invc_exit

	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a4, 0(a2)	# Load character in a5

	addi a3, a6, -1
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a3	# cypthertext_address + i
	lb a3, 0(a2)	# Load character in a5

	lw a0, 0(sp)	# load the address of ciphertext
	add a2, a0, a7	# ciphertext_address + i
	sb a3, 0(a2)	# Load character in a5

	addi a3, a6, -1
	lw a0, 0(sp)	# load the address of ciphertext
	add a2, a0, a3	# ciphertext_address + i
	sb a4, 0(a2)	# Load character in a5

	addi a7, a7, 1	#i++
	addi a6, a6, -1	#n--
	j invc_L1while
invc_exit:
	lw   ra, 8(sp) # Reload return address from stack
    addi sp, sp, 12 # Restore stack pointer
    ret

############################################
Inversion_deCipher:
	addi sp, sp, -12
    sw ra, 8(sp) # return address
	#la a0, cypthertext
    sw a0, 4(sp)  # cypthertext address
	#la a1, cypthertext
    sw a1, 0(sp)  # cypthertext address
	
	li a7, 0 #i
invdec_while:
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# Load character in a5
	beqz a5, invdec_L0
	addi a7, a7, 1	# i = i + 1
	j invdec_while
invdec_L0:
	mv a6, a7
	mv a5, a7
	srli a4, a5, 31
    add a5, a4, a5
    srai a5, a5, 1	#a5 = a5 / 2
	li a7, 0
invdec_L1while:
	bgt a7, a5, invdec_exit

	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a4, 0(a2)	# Load character in a5

	addi a3, a6, -1
	lw a0, 4(sp)	# load the address of cypthertext
	add a2, a0, a3	# cypthertext_address + i
	lb a3, 0(a2)	# Load character in a5

	lw a0, 0(sp)	# load the address of ciphertext
	add a2, a0, a7	# ciphertext_address + i
	sb a3, 0(a2)	# Load character in a5

	addi a3, a6, -1
	lw a0, 0(sp)	# load the address of ciphertext
	add a2, a0, a3	# ciphertext_address + i
	sb a4, 0(a2)	# Load character in a5

	addi a7, a7, 1	#i++
	addi a6, a6, -1	#n--
	j invdec_L1while
invdec_exit:
	lw   ra, 8(sp) # Reload return address from stack
    addi sp, sp, 12 # Restore stack pointer
    ret


############################################		
Occurrence_Cipher:
	addi sp, sp, -20
    sw ra, 16(sp) # return address
	#la a3, ntotbuff
    sw a3, 12(sp)  # ntotbuff address
	#la a2, filteredtext
    sw a2, 8(sp)  # filteredtext address
	#la a1, occctext
    sw a1, 4(sp)  # occctext address
	#la a0, cypthertext
    sw a0, 0(sp)  # cypthertext address

		sw      zero,-4(sp)		#i = i + 0
occc_wl_citooc:					#copy ciphertext into occctext
        lw     	a5,0(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)		#temp = ciphertext[i]
        lb      a5,-20(sp)
        beqz    a5,occc_add_z_oct	#jump if temp equal to zero
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#occtext[i] = temp
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i = i + 1
        j       occc_wl_citooc
occc_add_z_oct:					#add zero at the end of occctext
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#occtext[i] = 0
        sw      zero,-4(sp)		#i = i + 0
occc_wl_ftb_z:
        lw      a4,-4(sp)
        li      a5,100
        bgt     a4,a5,occc_wl_ftb_z_b		#break loop if i > 100
        lw      a5,8(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#filter_text[i] = 0
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i = i + 0
        j       occc_wl_ftb_z
occc_wl_ftb_z_b:				#find filter characters
        sw      zero,-4(sp)		#i = 0
occc_wl_ftc:					#loop find filter characters
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)	
        sb      a5,-20(sp)		#temp = occtext[i]
        lb      a5,-20(sp)
        beqz    a5,occc_wl_ftc_ex			#jump if temp equal to zero
        sw      zero,-8(sp)		#j = 0
        sb      zero,-16(sp)	#flag = 0
occc_wl_ftc_l1:
        lw      a5,8(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)		#itemp = filter_text[j]
        lb      a5,-24(sp)
        bnez    a5,occc_wl_ftc_l2	#jump if itemp is not equal to 0
        li      a5,1
        sb      a5,-16(sp)		#set flag
        j       occc_wl_ftc_l4
occc_wl_ftc_l2:
        lb      a4,-24(sp)
        lb      a5,-20(sp)
        bne     a4,a5,occc_wl_ftc_l3		#if itemp is not equal to temp
        sb      zero,-16(sp)	#flag = 0
        j       occc_wl_ftc_l4
occc_wl_ftc_l3:
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)		#j = j + 1
        j       occc_wl_ftc_l1
occc_wl_ftc_l4:
        lb      a5,-16(sp)
        beqz    a5,occc_wl_ftc_l5			#jump if flag = 0
        lw      a5,8(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#filter_text[j] = temp
occc_wl_ftc_l5:
        lw      a5,-4(sp)
        addi   	a5,a5,1
        sw      a5,-4(sp)		#i = i + 1
        j       occc_wl_ftc
occc_wl_ftc_ex:
        sw      zero,-4(sp)		#i = 0
        sw      zero,-28(sp)	#posind = 0
occc_wl_cipher:					#while loop encryption
        lw      a5,8(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)		#temp = filter_text[i]
        lb      a5,-20(sp)
        beqz    a5,occc_wl_c_ex			#if temp is not equal to zero
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#place temp in ciphertext[posind]
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posind = posind + 1
        sw      zero,-8(sp)		#j = 0
occc_wl_c_L1:
        lw      a5,4(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)		#itemp = occtext[j]
        lb      a5,-24(sp)
        beqz    a5,occc_wl_c_L6			#jump if itemp equal to zero
        lb      a4,-24(sp)
        lb      a5,-20(sp)
        bne     a4,a5,occc_wl_c_L5		#if itemp is not equal to temp
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        li      a4,45
        sb      a4,0(a5)		#place '-' at ciphertext[posind] = 45
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posind = posind + 1
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-32(sp)		#num = j + 1
        sw      zero,-12(sp)	#k = 0
occc_wl_c_L2:					#convert number to string reverse in order
        lw      a4,-32(sp)
        li      a5,9
        bgt     a4,a5,occc_wl_c_L3		#jump if num > 9
        lw      a5,-32(sp)
        addi    a4,a5,48
        lw      a5,12(sp)
        lw      a3,-12(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ntotbuff[k] = num + 48
        j       occc_wl_c_L4
occc_wl_c_L3:							#calculation for number greater then 9
        lw      a4,-32(sp)
        li      a5,10
        rem     a5,a4,a5
        sw      a5,-36(sp)		#remainder = num MOD 10
        lw      a5,-36(sp)
        addi    a4,a5,48
        lw      a5,12(sp)
        lw      a3,-12(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ntotbuff[k] = remainder + 48
        lw      a4,-32(sp)
        li      a5,10
        div     a5,a4,a5
        sw      a5,-32(sp)		#num = num / 10
        lw      a5,-12(sp)
        addi    a5,a5,1
        sw      a5,-12(sp)		# k = k + 1
        j       occc_wl_c_L2
occc_wl_c_L4:							#place the number string to ciphertext
        lw      a5,-12(sp)
        bltz    a5,occc_wl_c_L5			# jump if k < 0
        lw      a5,12(sp)
        lw      a4,-12(sp)
        add     a5,a4,a5
        lb      a4,0(a5)
        lw      a5,0(sp)
        lw      a3,-28(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ciphertext[posind] = ntotbuff[k]
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posind = posind + 1
        lw      a5,-12(sp)
        addi    a5,a5,-1
        sw      a5,-12(sp)		# k = k - 1
        j       occc_wl_c_L4

occc_wl_c_L5:
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)		#j = j+1
        j       occc_wl_c_L1
occc_wl_c_L6:
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        li      a4,32
        sb      a4,0(a5)		#add space, ciphertext[posind] = 32
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posind = posind + 1
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i	= i + 1
        j       occc_wl_cipher
occc_wl_c_ex:							#make sure to erase last space adding zero
        lw      a5,-28(sp)
        addi    a4,a5,-1
        lw      a5,0(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#ciphertext[posind-1] = 0

occc_ret:
		lw   ra, 16(sp) # Reload return address from stack
		addi sp, sp, 20 # Restore stack pointer
		ret

############################################
Occurrence_deCipher:
	addi sp, sp, -12
    sw ra, 8(sp) # return address
	#la a0, cypthertext
    sw a0, 4(sp)  # cypthertext address
	#la a1, occctext
    sw a1, 0(sp)  # occctext address
		
		
		sw      zero,-8(sp)			#j = 0
		sw      zero,-4(sp)			# i = 0
occdec_while:						#(while) loop over the characters
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-16(sp)			#ctemp = ciphertext[i]
        lb      a5,-16(sp)
        beqz    a5,occdec_L7		#if ctemp==0 jump occdec_L7
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i +1
occdec_L1:							#(while2) loop over the positions of a character
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)			#ttemp = ciphertext[i]
        lb      a5,-20(sp)
        sw      a5,-12(sp)			#temp = int(ttemp)
        lw      a4,-12(sp)
        li      a5,32
        bne     a4,a5,occdec_L2		#not space
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i+1
        j       occdec_L6			# if(temp == 32) {i++; break;}
occdec_L2:
        lw      a5,-12(sp)
        beqz    a5,occdec_L6		# if(temp == 0) { break;}
        lw      a4,-12(sp)
        li      a5,45
        beq     a4,a5,occdec_L5		# if temp == 45
        lw      a5,-12(sp)
        addi    a5,a5,-48
        sw      a5,-12(sp)			#convert char from ASCII to digit
occdec_L3:								#(while3) loop to calculate a position
        lw      a5,-4(sp)
        addi    a4,a5,1
        lw      a5,4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)			#while3   char temp_n = ciphertext[i+1]
        lb      a4,-24(sp)
        li      a5,47
        ble     a4,a5,occdec_L4			#jump if smaller then equalto 47
        lb      a4,-24(sp)
        li      a5,57
        bgt     a4,a5,occdec_L4			#jump if greater then 57
        lb      a5,-24(sp)
        addi    a5,a5,-48
        sb      a5,-24(sp)			#ASCII char to number temp_n
        lw      a5,-12(sp)
		li		a4, 10
		mul		a4, a5, a4
        lb      a5,-24(sp)
        add     a5,a4,a5
        sw      a5,-12(sp)			#temp = (temp * 10) + temp_n
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#position counter +1
        j       occdec_L3					#inner loop again
occdec_L4:
        lw      a5,-12(sp)
        addi    a5,a5,-1			#get the correct by subtracting 1
        sw      a5,-12(sp)			#store the correct position
        lw      a5,0(sp)
        lw      a4,-12(sp)
        add     a5,a4,a5
        lb      a4,-16(sp)
        sb      a4,0(a5)			#place char in char temp to occtext pointed by position temp
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)			#j = j + 1
occdec_L5:
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i + 1
        j       occdec_L1

occdec_L6:
        j       occdec_while
occdec_L7:
        lw      a5,0(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        sb      zero,0(a5)			#make sure to add zero

        sw      zero,-4(sp)			#i = i + 1
occdec_L8:								#while loop to copy string occctext to cypthertext
        lw      a5,0(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-16(sp)
        lb      a5,-16(sp)
        beqz    a5,occdec_exit				#if character in temp is zero then exit loop
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a4,-16(sp)
        sb      a4,0(a5)			#add char to ciphertext in temp
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#counter i = i + 1
        j       occdec_L8				#loop again
occdec_exit:
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)			#make sure to add zero at the end

occdec_ret:
	lw   ra, 8(sp) # Reload return address from stack
    addi sp, sp, 12 # Restore stack pointer
    ret	
	

########################################################################
printNewline:
    la a0, newline
    li a7, 4
    ecall
    ret
	
exit:
    li a7, 10
    ecall
