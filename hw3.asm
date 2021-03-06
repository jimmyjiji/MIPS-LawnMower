##############################################################
# Homework #3
# name: Jimmy Ji
# sbuid: 109259420	
# EXTRACREDIT
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
	sw $s3, 12($sp)		#push used s variables onto the stack 
				
				
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
	
	#################### test if read
	#li $v0, 4
	#la $a0, buffer
	#syscall 
	####################
	
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
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)		
	sw $s4, 16($sp)
	sw $s5, 20($sp)		#push used s variables onto the stack 
	
	#Define your code here
	la $s0, ($a0)		#set starting address of array to s0
	li $t7, 2		#set t7 to 2
	move $s1, $a1 
	addi $s2, $a2, 0	#set s2 to amount of rows in a2
	mul  $s3, $a3, $t7	#set s3 to amount of columns in a3
	
	andi $t0, $s1, 65280 	# first byte from s1 to t0
	sra $t0, $t0, 8
	andi $t1, $s1, 255	# second byte from s1 to t1
	
	move $t2, $t1		#swap bytes because of endianess 
	move $t1, $t0
	move $t0, $t2
	
	######################################### test
	
	#li $v0, 4
	#la $a0, nextline
	#syscall
	
	#li $v0, 11
	#move $a0, $t0
	#syscall
	#move $a0, $t1
	#syscall
	
	########################################## test
	li $t2, 0 		# row counter 
	li $t3, 0		# column counter 
	row:
		
		bge $t2, $s2, endLoop		#if i = row amount, end loop 
		
		column: 
			bge $t3, $s3, nextRow
			lb $t4, ($s0)		#t4 is set to bit of address
			bne $t0, $t4, add2	#if the first bit isn't equal, no need to check y, jump 2 bits
			beq $t0, $t4, eqfirstbit
		
		add2:
			addi $t3, $t3, 2
			addi $s0, $s0, 2
			j column
		add1:
			addi $t3, $t3, 1
			addi $s0, $s0, 1
			j column
		eqfirstbit:
			move $s4, $t2		#set s4 to row#
			addi $t3, $t3, 1
			addi $s0, $s0, 1
			lb $t4, ($s0)
			beq $t1, $t4, eqsecondbit
			j add1
		eqsecondbit:
			move $s5, $t3		#set s5 to column number
			move $v0, $s4		#set v0 to row number
			addi $v1, $s5, -1
			div $v1, $t7		#divide columns by 2
			mflo $v1		#set v1 to quotient in mflo. 
			
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)		
			lw $s4, 16($sp)
			lw $s5, 20($sp)		#pull used s variables onto the stack 
			
			jr $ra
	nextRow:
		addi $t2, $t2 1
		li $t3, 0
		j row
			
	endLoop:
	li $v0, -1
	li $v1, -1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)		
	lw $s4, 16($sp)
	lw $s5, 20($sp)		#pop used s variables onto the stack 
	
	jr $ra
##############################
# PART 2/3 FUNCTION
##############################

playGame:
	#Define your code here
	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)		
	sw $s4, 16($sp)
	sw $s5, 20($sp)		#push used s variables onto the stack 
	sw $s6, 24($sp)
	
	
	la $s0, ($a0)		#base address
	move $s1, $a1		#row
	move $s2, $a2		#column	
	la $s3, ($a3)		#command line
	li $s4, 43		#lawnmower 
	li $s5, 32		#space 
	li $s6, 0		#position locator 
	
	bltz $s1, defaultLocation	#if row is -1, start mower at default location 
	j changeMowerLocation
	
	defaultLocation:
		li $t0, 80
		li $t1, 0		#address incrementer 
		li $t2, 2
		lw $t3, X
		lw $t4, Y
		mul $t3, $t3, $t0	#multiply the rows by 80
		add  $t1, $t3, $t4	#add the column numbers to the row
		mul $t1, $t1, $t2	
		add $s0, $s0, $t1
		sb $s5, 2($s0)		#delete the lawnmower 
		j start
		
		
	changeMowerLocation:
		li $t0, 80
		li $t1, 0		#address incrementer 
		li $t2, 2		
		mul $s1, $s1, $t0	#multiply the rows by 80
		add  $t1, $s1, $s2	#add the column numbers to the row
		mul $t1, $t1, $t2	#multiply by 2
		add $s0, $s0, $t1
		j start
	
		
	start:
	move $s6, $t1		#set position locator to current location 
	lb $t0, ($s3)		#load the first byte of the command line 
	
	
	beginGame:
		beqz $t0, endGame	#if the command line ends, go to end game 
		
		beq $t0, 119, w
		beq $t0, 97, a
		beq $t0, 115, s
		beq $t0, 100, d
		j nextcommand
		
		w:	
			blt $s6, 160, wrapW						
			#################
			lb $t1, -159($s0)
			lb $t2, -160($s0)
			sll $t3, $t1, 8
			or $t3, $t3, $t2
			move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
			##################
			li $t2, 0xffffb06f		#flowers 
			li $t3, 0x00007f52		#rocks
			li $t4, 0x00002f5e		#tree
			li $t5, 0x00003f20		#dirt
			li $t6, 0x00004f20		#water 
			
			beq $t1, $t2, nextcommand
			beq $t1, $t3, nextcommand
			beq $t1, $t4, nextcommand
			beq $t1, $t5, nextcommand
			beq $t1, $t6, nextcommand
			#########################################	checks collision 
			
			j normalW
			
			wrapW:
				lb $t1, 3841($s0)
				lb $t2, 3840($s0)
				sll $t3, $t1, 8
				or $t3, $t3, $t2
				move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
				##################
				li $t2, 0xffffb06f		#flowers 
				li $t3, 0x00007f52		#rocks
				li $t4, 0x00002f5e		#tree
				li $t5, 0x00003f20		#dirt
				li $t6, 0x00004f20		#water 
			
				beq $t1, $t2, nextcommand
				beq $t1, $t3, nextcommand
				beq $t1, $t4, nextcommand
				beq $t1, $t5, nextcommand
				beq $t1, $t6, nextcommand
				#########################################	checks collision in wrapping
				
				
				
				li $t1, 24
				li $t2, 160
				mul $t3, $t1, $t2	#set adding address to t3
				sb $s5, ($s0)		#delete the lawnmower 
				addi $s0, $s0, 1	#go up to delete the grass address	
				lb $t1, ($s0) 		#create temp register for value at current address
				ori $t1, $t1, 128	#make the bold bit 1
				sb $t1, ($s0)		#store the change into current address
				add $s0, $s0, $t3	#go up row 
				addi $s0, $s0, -1
				sb $s4, ($s0)		#create lawnmower 
				add $s6, $s6, $t3	#move position locator 
				
			normalW:
			sb $s5, ($s0)		#delete the lawnmower 
			addi $s0, $s0, 1	#go up to delete the grass address
			lb $t1, ($s0) 		#create temp register for value at current address
			ori $t1, $t1, 128	#make the bold bit 1
			sb $t1, ($s0)		#store the change into current address
			addi $s0, $s0, -161	#go up row 
			sb $s4, ($s0)		#create lawnmower 
			addi $s6, $s6, -160	#move position locator 
			j nextcommand
				
		a:
			
			#################
			lb $t1, -1($s0)
			lb $t2, -2($s0)
			sll $t3, $t1, 8
			or $t3, $t3, $t2
			move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
			##################
			li $t2, 0xffffb06f		#flowers 
			li $t3, 0x00007f52		#rocks
			li $t4, 0x00002f5e		#tree
			li $t5, 0x00003f20		#dirt
			li $t6, 0x00004f20		#water 
			
			beq $t1, $t2, nextcommand
			beq $t1, $t3, nextcommand
			beq $t1, $t4, nextcommand
			beq $t1, $t5, nextcommand
			beq $t1, $t6, nextcommand
			#########################################	checks collision 
			
			li $t1, 160
			div $s6, $t1
			mfhi $t1 
			beqz $t1, wrapA
			j normalA
			
			wrapA:
				#################
				lb $t1, 158($s0)
				lb $t2, 159($s0)
				sll $t3, $t1, 8
				or $t3, $t3, $t2
				move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
				##################
				li $t2, 0xffffb06f		#flowers 
				li $t3, 0x00007f52		#rocks
				li $t4, 0x00002f5e		#tree
				li $t5, 0x00003f20		#dirt
				li $t6, 0x00004f20		#water 
			
				beq $t1, $t2, nextcommand
				beq $t1, $t3, nextcommand
				beq $t1, $t4, nextcommand
				beq $t1, $t5, nextcommand
				beq $t1, $t6, nextcommand
				#########################################	checks collision in wrap
			
			
				sb $s5, ($s0)		#delete the lawnmower 
				addi $s0, $s0, 158	#go up address
				sb $s4, ($s0)		#create lawnmower 
				addi $s6, $s6, 158	#move position locator 
				j nextcommand
			
			normalA:
			sb $s5, ($s0)		#delete the lawnmower 
			addi $s0, $s0, 1	#go up to delete the grass address
			lb $t1, ($s0) 		#create temp register for value at current address
			ori $t1, $t1, 128	#make the bold bit 1
			sb $t1, ($s0)		#store the change into current address
			addi $s0, $s0, -3	#go back address
			sb $s4, ($s0)		#create lawnmower 
			addi $s6, $s6, -2	#move position locator 
			j nextcommand
			
			
		s:	
			bge $s6, 3840, wrapS
			#################
			lb $t1, 161($s0)
			lb $t2, 160($s0)
			sll $t3, $t1, 8
			or $t3, $t3, $t2
			move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
			##################
			li $t2, 0xffffb06f		#flowers 
			li $t3, 0x00007f52		#rocks
			li $t4, 0x00002f5e		#tree
			li $t5, 0x00003f20		#dirt
			li $t6, 0x00004f20		#water 
			
			beq $t1, $t2, nextcommand
			beq $t1, $t3, nextcommand
			beq $t1, $t4, nextcommand
			beq $t1, $t5, nextcommand
			beq $t1, $t6, nextcommand
			#########################################	checks collision 
			j normalS
			
			wrapS:
				#################
				lb $t1, -3841($s0)
				lb $t2, -3840($s0)
				sll $t3, $t1, 8
				or $t3, $t3, $t2
				move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
				##################
				li $t2, 0xffffb06f		#flowers 
				li $t3, 0x00007f52		#rocks
				li $t4, 0x00002f5e		#tree
				li $t5, 0x00003f20		#dirt
				li $t6, 0x00004f20		#water 
			
				beq $t1, $t2, nextcommand
				beq $t1, $t3, nextcommand
				beq $t1, $t4, nextcommand
				beq $t1, $t5, nextcommand
				beq $t1, $t6, nextcommand
			#########################################	checks collision for wrap
			
				li $t1, 24
				li $t2, 160
				mul $t3, $t1, $t2	#set adding address to t3
				sb $s5, ($s0)		#delete the lawnmower 
				addi $s0, $s0, 1	#go up to delete the grass address	
				lb $t1, ($s0) 		#create temp register for value at current address
				ori $t1, $t1, 128	#make the bold bit 1
				sb $t1, ($s0)		#store the change into current address
				sub $s0, $s0, $t3	#go back row 
				addi $s0, $s0, -1
				sb $s4, ($s0)		#create lawnmower 
				sub $s6, $s6, $t3	#move position locator 
				
			normalS:
			sb $s5, ($s0)		#delete the lawnmower 
			addi $s0, $s0, 1	#go up to delete the grass address
			lb $t1, ($s0) 		#create temp register for value at current address
			ori $t1, $t1, 128	#make the bold bit 1
			sb $t1, ($s0)		#store the change into current address
			addi $s0, $s0, 159	#go down row 
			sb $s4, ($s0)		#create lawnmower 
			addi $s6, $s6, 160	#move position locator 
			j nextcommand
		d:
			#################
			lb $t1, 3($s0)
			lb $t2, 2($s0)
			sll $t3, $t1, 8
			or $t3, $t3, $t2
			move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
			##################
			li $t2, 0xffffb06f		#flowers 
			li $t3, 0x00007f52		#rocks
			li $t4, 0x00002f5e		#tree
			li $t5, 0x00003f20		#dirt
			li $t6, 0x00004f20		#water 
			
			beq $t1, $t2, nextcommand
			beq $t1, $t3, nextcommand
			beq $t1, $t4, nextcommand
			beq $t1, $t5, nextcommand
			beq $t1, $t6, nextcommand
			#########################################	checks collision 
			
			li $t1, 160
			div $s6, $t1
			mfhi $t1 
			beqz $t1, wrapD
			j normalD
			
			wrapD:
				#################
				lb $t1, -159($s0)
				lb $t2, -158($s0)
				sll $t3, $t1, 8
				or $t3, $t3, $t2
				move $t1, $t3		#set t1 as previous 2 bytes without having to deal with lh shenanigans 
				##################
				li $t2, 0xffffb06f		#flowers 
				li $t3, 0x00007f52		#rocks
				li $t4, 0x00002f5e		#tree
				li $t5, 0x00003f20		#dirt
				li $t6, 0x00004f20		#water 
			
				beq $t1, $t2, normalA
				beq $t1, $t3, normalA
				beq $t1, $t4, normalA
				beq $t1, $t5, normalA
				beq $t1, $t6, normalA
				#########################################	checks collision in wrap
			
				
				
				sb $s5, ($s0)		#delete the lawnmower 
				addi $s0, $s0, -160	#go back address
				sb $s4, ($s0)		#create lawnmower 
				addi $s6, $s6, -160	#move position locator 
				j normalD
			########################################
			
			normalD:
			sb $s5, ($s0)		#delete the lawnmower 
			addi $s0, $s0, 1	#go up address
			lb $t1, ($s0) 		#create temp register for value at current address
			ori $t1, $t1, 128	#make the bold bit 1
			sb $t1, ($s0)		#store the change into current address
			addi $s0, $s0, 1	#go up address
			sb $s4, ($s0)		#create lawnmower 
			addi $s6, $s6, 2	#move position locator 
			j nextcommand
		
			
			
		nextcommand:
			li $v0, 32
			li $a0, 500
			syscall			#sleep
			
			addi $s3, $s3, 1	#increment command line 
			lb $t0, ($s3)		#reload the t0 checker 
			j beginGame
	endGame:	
	
	li $t0, 80
	li $t1, 2
	div $s6, $t1
	mflo $s6 
	div $s6, $t0
	mflo $t0	#row
	mfhi $t1	#column
	sb $t0, X
	sb $t1, Y
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)		
	lw $s4, 16($sp)
	lw $s5, 20($sp)		#pop used s variables onto the stack 
	lw $s6, 24($sp)
	
	jr $ra
	
extracred:
	la $t2, extracredit
	writeex:	
		
		lb $t3, ($t2)	#get byte from buffer address into t3
		sb $t3, ($a0)	#set address of $s0 to byte $t3
		
		addi $t2, $t2, 1
		addi $a0, $a0, 1
		addi $t0, $t0, 1
		
		beqz $t2, closeextracred
		blt $t0, 2400, writeex 	#if its less than the total length of the extra credit keep printing 
closeextracred:
	jr $ra

.data
	#Define your memory here 

buffer: .space 4000
nextline: .asciiz "\n"
X: .word 24
Y: .word 79
extracredit: .asciiz " / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ? ? ? ? ? ? � � � � ? ? � � � � � ? ? � � � � � ? ? � � � � � ? ? � � � � � ? ? � � � � � ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? O O O O O O � O O O O O � O O O O O O � O O O O O O O O O � O O O O O O � O O O � O O O � O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O _ _ _ _ _ _ � _ _ _ _ _ � � � � � _ _ � � � � � _ _ _ _ � _ _ _ _ _ _ � _ _ _ _ � _ _ _ � _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ o o o o o o � o o o o o o o o o � o o � o o o o o o o � o o o o o o � o o o o o � o o o � o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o / / / / / / � � � � / / � � � � � / / � � � � � / / � � � � � / / � � � � � / / � � � � � / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o"     
