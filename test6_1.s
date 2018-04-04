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
  # len -> a0
  # wormCol -> s0
  # wormRow -> s1
  # i -> t0
  # s2 -> '@'
  # s3 -> 'o'

  li    $t1, 0
  li    $t2, 1            # char size is 1
  li    $t3, 4            # int size is 4
  li    $t4, 40           # col is 40
  li    $s2, 'o'          # s2 = o
  li    $s3, '@'          # s3 = @

  mul   $t5, $t4, $t2     # rowsize = col * charsize
  lw    $s0, wormCol($t1) # col = wormCol[0]
  lw    $s1, wormRow($t1) # row = wormRow[0]

  mul   $t6, $s1, $t5     # t6 = rows * rowsize
  mul   $t7, $s0, $t2     # t7 = col * charsize
  add   $t6, $t6, $t7     # offset = t6 + t7
  sb    $s3, grid($t6)    # grid[row][col] = @

  li    $t0, 1            # i = 1
add_loop:
  bge   $t0, $a0, end_add
  mul   $t1, $t0, $t3          # t1 = i * intsize
  lw    $s0, wormCol($t1)      # s0 = wormCol[i]
  lw    $s1, wormRow($t1)      # s1 = wormRow[i]

  mul   $t6, $s1, $t5          # t6 = row * rowsize
  mul   $t7, $s0, $t2          # t7 = col * charsize
  add   $t6, $t6, $t7          # offset = t6 + t7
  sb    $s2, grid($t6)         # grid[row][col] = o

  addi  $t0, $t0, 1            # i ++
  j     add_loop

end_add:
# tear down stack frame
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra
