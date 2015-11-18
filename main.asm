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
	
	
	#la $a0, 4294901760 #base address  
	#move $a1, $v0	
	#move $a2, $v1
	#la $a3, command 
	#jal playGame
	
	#la $a0, 4294901760 #base address  
	#li $a1, -1	
	#li $a1, -1
	#la $a3, command
	#jal playGame
	
	la $a0, 4294901760 #base address  
	li $a1, -1	
	li $a1, -1
	la $a3, command
	jal playGame
	
	#la $a0, 0xffff0000 #base address  
	#la $a1, 0xffff0f9f
	#jal extracred
	
	end:
	li $v0, 10
	syscall 


.data 
filename: .asciiz "hw3/landscape2.map" 
.align 2
shortvalue: .asciiz "+/xx"	#searching for lawn mower 
command: .asciiz "aaaaassssswwwwwwwsssssss"
command2: .asciiz "dddddaaaaaaa"
.include "hw3.asm"
