.text
initWorm:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $a2, $t0, $t1, $t2
# Clobbers:	$t0, $t1, $t2

# Locals:
#	- `col' in $a0
#	- `row' in $a1
#	- `len' in $a2
#	- `newCol' in $t0
#	- `nsegs' in $t1
#	- temporary in $t2

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

### TODO: Your code goes here
    
    move    $s5, $a0        # s5 = col
    move    $s6, $a1        # s6 = row
    move    $s7, $a2        # s7 = len
    
    li      $t2, 4          # int size is 4
    li      $t1, 1          # nsegs = 1
    li      $t3, 0
    add     $t0, $t0, $s5
    addi    $t0, $t0, 1     # newCol = col + 1
    sw      $s5, wormCol($t3)       # wormCol[0] = col
    sw      $s6, wormRow($t3)       # wormRow[0] = row
    
    if:
        bge    $t1, $s7, else
        li     $v0, 1
        j      return
    else:
        
        addi   $t0, $t0, 1          # newCol ++
        mul    $t2, $t2, $t1        # wormCol[nsegs] = nsegs * intsize
        sw     $t0, wormCol($t2)    # wormCol[nsegs] = newCol ++
        sw     $s6, wormRow($t2)    # wormRow[nsegs] = row
        addi   $t1, $t1, 1          # nsegs ++ 
        
    return: 
	# tear down stack frame
	    lw	$ra, -4($fp)
	    la	$sp, 4($fp)
	    lw	$fp, ($fp)
	    jr	$ra


