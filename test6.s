# .TEXT <addWormToGrid>
	.text
addWormToGrid:

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3
# Uses: 	$a0, $s0, $s1, $s2, $s3, $t1
# Clobbers:	$t1

# Locals:
#	- `len' in $a0
#	- `&wormCol[i]' in $s0
#	- `&wormRow[i]' in $s1
#	- `grid[row][col]'
#	- `i' in $t0

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	sw	$s2, -20($sp)
	sw	$s3, -24($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -24

### TODO: your code goes here
	move  $s0, $a0
	li    $t1, 0
	li    $t2, 1
	li    $t3, 4
	mul   $t5, 40, $t2                  # rowsize = col * charsize
	lw    $s2, wormRow($t1)							# row = wormRow[0]
	lw    $s3, wormCol($t1)							# col = wormCol(0)

	mul   $t6, $s2, $t5									# t6 =  row * rowsize
	mul   $t7, $s3, $t2									# t7 = col * charsize
	add   $t6, $t6, $t7									# offset = t6 + t7
	sb    '@',  grid($t6)								# grid[row][col] = @

	li    $t0, 1
	li    $t1, 1												# reset t1 = 1
add_loop:
	bge   $t0, $s0, end4									# i < len

	mul   $t1, $t1, $t3									# t1 = t1 * intsize
	lw    $s2, wormRow($t1)							# row = wormRow[i]
	lw    $s3, wormCol($t1)							# col = wormCol[i]

	mul   $t6, $s2, $t5									# t6 =  row * rowsize
	mul   $t7, $s3, $t2									# t7 = col * charsize
	add   $t6, $t6, $t7									# offset = t6 + t7
	sb    'o',  grid($t6)								# grid[row][col] = o
	
	# tear down stack frame
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

####################################
# giveUp(msg) ... print error message and exit
# .TEXT <giveUp>
