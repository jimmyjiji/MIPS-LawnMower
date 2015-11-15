.globl main
.text
main:

	
 
	la $a0, 4294901760
	la $a1, filename
	li $a2, 4000
	jal arrayFill
	
	beq $v0, -1, end 
	
	la $a0, 4294901760 #base address  
	lh $a1, shortvalue
	li $a2, 25	#rows
	li $a3, 80	#columns 
	jal find2Byte
	
	################### test location
	#move $a0, $v0
	#li $v0, 1
	#syscall
	

	#move $a0, $v1
	#syscall
	###################
	
	
	la $a0, 4294901760 #base address  
	move $a1, $v0	
	move $a2, $v1
	la $a3, command 
	jal playGame
	
	
	end:
	li $v0, 10
	syscall 


.data 
filename: .asciiz "hw3/landscape1.map" 
.align 2
shortvalue: .asciiz "+/xx"	#searching for lawn mower 
command: .asciiz "aaa"

.include "hw3.asm"
