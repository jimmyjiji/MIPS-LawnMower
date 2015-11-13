##############################################################
# Homework #3
# name: Jimmy Ji
# sbuid: 109259420	
##############################################################
.text

##############################
# Part 1 FUNCTION
##############################

arrayFill:
	#Define your code here
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
				#push used s variables onto the stack 
				
	la $s0, ($a0)		#set starting address of array to s0
	la $s1, ($a1)		#set s1 to address of file name 
	addi $s2, $a2, 0	#set s2 to amount in a2

#open
	li $v0, 13		#open file
	la $a0, ($s1)		#open filename
	li $a1, 0		#set to read
	li $a2, 0		#set to ignore 
	beqz $v0, error
	syscall 
	move $s3, $v0 
#read	
	move $a0, $v0        	# load file descriptor
	li $v0, 14           	#read from file
	la $a1, buffer       	# allocate space for the bytes loaded
	addi $a2, $s2, 0	# number of bytes to be read
	syscall  
#write	
	la $a0, buffer  	# address of string to be printed
	
	li $t0, 0		#set counter for maxBytes check
	li $t1, 0		#set counter for return 
	
	li $v0, 4
	syscall 
	la $t2, buffer
	write:	
		
		lb $t3, ($t2)	#get byte from buffer address into t3
		sb $t3, ($s0)	#set address of $s0 to byte $t3
		
		addi $t2, $t2, 1
		addi $s0, $s0, 1
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		
		beqz $t2, close_and_end
		blt $t0, $s2, write 	#if t0 is less than s2, then continue looping 
close_and_end: 
#close reader
	li $v0, 16
	move $a0, $s3
	syscall 
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)			#removed used s variables from stack 
	
	move $v0, $t1
	jr $ra
#return -1 if error 
error:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)			#removed used s variables from stack 
	
	li $v0, -1
	jr $ra 

find2Byte:
	#Define your code here
	

##############################
# PART 2/3 FUNCTION
##############################

playGame:
	#Define your code here
	


.data
	#Define your memory here 

buffer: .space 10000
