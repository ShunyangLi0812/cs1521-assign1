	.globl	overlaps

    .text
main:

	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8
	li    $a0, 15
	li    $a1, 10
	li    $a3, 9
	jal   overlaps

	move  $a0, $v0
	li    $v0, 1
	syscall

	li    $a0, '\n'
	li    $v0, 11
	syscall

	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra


	.text
overlaps:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $a2
# Clobbers:	$t6, $t7

# Locals:
#	- `col' in $a0
#	- `row' in $a1
#	- `len' in $a2
#	- `i' in $t6

# Code:

### TODO: complete this function

	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

	# code for function
	li    $t1, 4							# intsize 4
	li    $t6, 0							# i = 0

for:
	bge   $t6, $a2, end_over
	mul   $t2, $t1, $t6
	lw    $t3, wormCol($t2)
	lw    $t4, wormRow($t2)

	bne   $a0, $t3, else_over
	bne   $a1, $t4, else_over
	# if wormCol[i] == col && wormRow[i] == row, return 1
	li    $v0, 1
	lw	  $ra, -4($fp)
	la	  $sp, 4($fp)
	lw	  $fp, ($fp)
	jr	  $ra
	jr    $ra
else_over:
	addi  $t6, $t6, 1
	j     for
end_over:
	li    $v0, 0
	# tear down stack frame
	lw	  $ra, -4($fp)
	la	  $sp, 4($fp)
	lw	  $fp, ($fp)
	jr	  $ra
