	.text
onGrid:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $v0
# Clobbers:	$v0

# Locals:
#	- `col' in $a0
#	- `row' in $a1

# Code:

### TODO: complete this function

	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8
	
    # code for function
    move    $s5, $a0        # s5 = col
    move    $s6, $a1        # s6 = row
    
if:
    bge     $s5, 0, else
    blt     $s5, 40, else
    bge     $s6, 0, else
    blt     $s6, 40, else
    li      $v0, 1
    jr      $ra
else:  
    li      $v0, 0
	# tear down stack frame
    lw	$ra, -4($fp)
    la	$sp, 4($fp)
    lw	$fp, ($fp)
    jr	$ra


####################################
# overlaps(r,c,len) ... checks whether (r,c) holds a body segment
# .TEXT <overlaps>
