.globl main
.text
main:

	
 
	la $a0, 4294901760
	la $a1, filename
	li $a2, 100000
	jal arrayFill
	
	li $v0, 10
	syscall 


.data 
filename: .asciiz "hw3/partial_filled_green.map" 


.include "hw3.asm"