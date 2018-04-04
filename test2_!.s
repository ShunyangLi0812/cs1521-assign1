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

  # col -> a0
  # row -> a1
  # len -> a2
  # newCol -> t0
  # nsegs -> t1
  # tmp -> t2

  li    $t1, 1                 # nsegs = 1
  li    $t2, 0
  li    $t3, 4                 # intsize 4
  li    $t4, 40
  add   $t0, $a0, $t1          # newCol = col + 1

  sw    $a0, wormCol($t2)      # wormCol[0] = col
  sw    $a1, wormRow($t2)      # wormRow[0] = row

init_loop:
  bge   $t1, $a2, end_init
  bne   $t0, $t4, end_init
  mul   $t3, $t3, $t1           # find the array position
  addi  $t0, $t0, 1             # newCol ++
  sw    $t0, wormCol($t3)       # wormCol[nsegs] = col
  sw    $a1, wormRow($t3)       # wormRow[nsegs] = row

  addi  $t1, $t1, 1
  j     init_loop

end_init:

# tear down stack frame
  lw	$ra, -4($fp)
  la	$sp, 4($fp)
  lw	$fp, ($fp)
  jr	$ra
