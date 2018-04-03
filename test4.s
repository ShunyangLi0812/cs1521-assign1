# overlaps(r,c,len) ... checks whether (r,c) holds a body segment
# .TEXT <overlaps>
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

### TODO: Your code goes here
    
    move    $s5, $a0        # s5 = col
    move    $s6, $a1        # s6 = row
    move    $s7, $a2        # s7 = len
    
    li      $t6, 0          # i = 0
    li      $t7, 4
    
check_loop:
    
    bge     $t6, $s7, end_check_loop        # i = 0; i < len, loop
    mul     $t7, $t7, $t6
    beq $s5, wormCol($t7), else             # if wormCol[i] == col continue check, else continue loop
    beq $s6, wormRow($t7), else             # if wormRow[i] == row, return 1
    li  $v0, 1
    jr  $ra
    
else:                                       # if wormCol[i] != col || wormRow[i] != row, continue loop
     addi $t6, $t6,1
     j    check_loop
 
end_check_loop:
    
    li  $v0, 0
	# tear down stack frame

    lw	$ra, -4($fp)
    la	$sp, 4($fp)
    lw	$fp, ($fp)
    jr	$ra
