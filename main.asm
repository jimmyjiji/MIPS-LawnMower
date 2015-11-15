.globl main
.text
main:

	
 
	la $a0, 4294901760
	la $a1, filename
	li $a2, 4000
	jal arrayFill
	
	
	la $a0, 4294901760 #base address  
	lh $a1, shortvalue
	li $a2, 25	#rows
	li $a3, 80	#columns 
	jal find2Byte
	
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	move $a0, $v1
	syscall
	
	
	li $v0, 10
	syscall 


.data 
filename: .asciiz"//files/UndergradHome/jjji/Desktop/hw3/landscape1.map" 
shortvalue: .asciiz "asxx"	#searching for " z"

.include "hw3.asm"
