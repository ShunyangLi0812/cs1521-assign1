# (col,row) coords of possible places for segments
# done as global data; putting on stack is too messy
	.data
	.align 4
possibleCol: .space 8 * 4	# sizeof(word)
possibleRow: .space 8 * 4	# sizeof(word)

# .TEXT <moveWorm>
  .text
moveWorm:

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7
# Uses: 	$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0, $t1, $t2, $t3
# Clobbers:	$t0, $t1, $t2, $t3

# Locals:
#	- `col' in $s0
#	- `row' in $s1
#	- `len' in $s2
#	- `dx' in $s3
#	- `dy' in $s4
#	- `n' in $s7
#	- `i' in $t0
#	- tmp in $t1
#	- tmp in $t2
#	- tmp in $t3
# 	- `&possibleCol[0]' in $s5
#	- `&possibleRow[0]' in $s6

# Code:
# set up stack frame
  sw	$fp, -4($sp)
  sw	$ra, -8($sp)
  sw	$s0, -12($sp)
  sw	$s1, -16($sp)
  sw	$s2, -20($sp)
  sw	$s3, -24($sp)
  sw	$s4, -28($sp)
  sw	$s5, -32($sp)
  sw	$s6, -36($sp)
  sw	$s7, -40($sp)
  la	$fp, -4($sp)
  addiu	$sp, $sp, -40
  ### TODO: Your code goes here
  li    $s7, 0                  # n = 0
  li    $s3, -1                 # dx = -1
  li    $t4, 4                  # sizeof(int) = 4
  move  $s2, $a0                # s2 -> length

move_loop1:
  bgt   $s3, 1, end_move1
  li    $s4, 1
move_loop2:
  bgt   $s4, 1, end_move2

  li    $t5, 0                  # index of arrays
  lw    $t1, wormCol($t5)       # t1 = wormCol[0]
  add   $t1, $t1, $s3           # t1 = t1 + dx
  move  $s0, $t1                # col = t1

  lw    $t1, wormRow($t5)       # t1 = wormRow[0]
  add   $t1, $t1, $s4           # t1 = t1 + dy
  move  $s1, $t1                # row = tq

  move  $a0, $s0
  move  $a1, $s1
  jal   onGrid                  # onGrid(col, row)
  move  $t2, $v0                # t2 = onGrid(col, row)

  move  $a0, $s0
  move  $a1, $s1
  move  $a2, $s2
  jal   overlaps
  move  $t3, $v0                 # t3 = overlaps(col, row, len)

move_if:
  bne   $t2, 1, end_if
  bne   $t3, 0, end_if
  mul   $t6, $s7, $t4
  sw    $s0, possibleCol($t6)     # possibleCol[n] = col
  sw    $s1, possibleRow($t6)     # possibleRow[n] = row
  addi  $s7, $s7, 1               # n++

  j     end_if
end_if:
  add   $s4, $s4, 1               # dy ++
  j     move_loop1                # reback
end_move2:
  add   $s3, $s3, 1               # dx ++
  j     move_loop1                # reback
end_move1:

  beq   $s7, 0, n_return          # n == 0
  sub   $t0, $s2, 1
worm_loop:
  ble   $t0, 0, end_worm          # if i = len - 1; i > 0

  mul   $t3, $t0, $t4             # t3 = i * 4
  add   $t1, $t0, -1              # t1 = i - 1
  mul   $t2, $t1, $t4             # t2 = (i - 1) * 4
  lw    $t5, wormRow($t2)         # t5 = wormRow[i - 1]
  sw    $t5, wormRow($t3)         # wormRow[i] = t5

  mul   $t3, $t0, $t4             # t3 = i * 4
  add   $t1, $t0, -1              # t1 = i - 1
  mul   $t2, $t1, $t4             # t2 = (i - 1) * 4
  lw    $t5, wormCol($t2)         # t5 = wormCol[i - 1]
  sw    $t5, wormCol($t3)         # wormCol[i] = t5

  sub   $t0, $t0, 1               # i --
  j      worm_loop

end_worm:

  move  $a0, $s7
  jal   randValue
  move  $t0, $v0                  # i = randValue(n)
  mul   $t3, $t0, $t4             # i * 4, array position

  li    $t5, 0                    # the index of array
  lw    $t6, possibleRow($t3)     # t6 = possibleRow[i]
  sw    $t6, wormRow($t5)         # wormRow[0] = t6

  lw    $t6, possibleCol($t3)     # t6 = possibleCol[i]
  sw    $t6, wormCol($t5)         # wormCol[0] = t6

  lw	$s7, -36($fp)
  lw	$s6, -32($fp)
  lw	$s5, -28($fp)
  lw	$s4, -24($fp)
  lw	$s3, -20($fp)
  lw	$s2, -16($fp)
  lw	$s1, -12($fp)
  lw	$s0, -8($fp)
  lw	$ra, -4($fp)
  la	$sp, 4($fp)
  lw	$fp, ($fp)
  li  $v0, 1
  jr	$ra


n_return:
  lw	$s7, -36($fp)
  lw	$s6, -32($fp)
  lw	$s5, -28($fp)
  lw	$s4, -24($fp)
  lw	$s3, -20($fp)
  lw	$s2, -16($fp)
  lw	$s1, -12($fp)
  lw	$s0, -8($fp)
  lw	$ra, -4($fp)
  la	$sp, 4($fp)
  lw	$fp, ($fp)
  li    $v0, 0
  jr    $ra

  # tear down stack frame
