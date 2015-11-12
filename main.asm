.globl main
.text
main:

#open
	li $v0, 13		#open file
	la $a0, filename	#open filename
	li $a1, 0		#set to read
	li $a2, 0		#set to ignore 
	syscall 
#read	
	move $a0, $v0        	# load file descriptor
	li $v0, 14           	#read from file
	la $a1, buffer       	# allocate space for the bytes loaded
	li $a2, 1000		# number of bytes to be read
	syscall  
#print	
	la $a0, contents    	# address of string to be printed
	li $v0, 4            	# print string	
	syscall 
#close reader
	li $v0, 16
	move $a0, $t0
	syscall 


.data 
filename: .asciiz "hw3/hw3/checker.map" 
contents: .ascii "File contents: "
buffer: .space 1000

