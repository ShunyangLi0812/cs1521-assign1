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
  move    $s2, $a0                      # s2 = len
  li      $s7, 0                        # n = 0
  li      $s3, -1                       # dx = -1
  li      $t4, 4                        # sizeof(int) = 4 = t4

move_loop1:
  bgt     $s3, 1, end1                  # if dx <= 1
  li      $s4, -1                       # dy = -1
move_loop2:
  bgt     $s4, 1, end2

  li      $t1, 0                        # tem = 0
  li      $t2, 0                        # a tmp
  add     $t2, $t2, $s3                 # t2 = dx
  add     $t2, $t2, wormCol($t1)        # t2 = t2 + wormCol($t1) 0
  move    $s0, $t2                      # col = t2

  li      $t2, 0                        # reset t2 = 0
  add     $t2, $t2, $s4                 # t2 = dy
  add     $t2, $t2, wormRow($t1)        # t2 = t2 + wormRow($t1), t1 = 0
  move    $s1, $t2                      # rows = t1

  move    $a0, $s0                      # jal onGrid
  move    $a1, $s1
  jal     onGrid
  move    $t3, $v0                      # t3 = 1 or 0

  move    $a0, $s0                      # jal overlaps
  move    $a1, $s1
  move    $a2, $s2
  jal     overlaps
  move    $t2, $v0                      # t2 = 1 or 0

  #######################
  # not correct
  bne     $t3, 1, move_loop2            # if t3 == 1
  beq     $t2, 1, move_loop2            # if t2 != 1
  mul     $t1, $t4, $s7                 # t1 = n * intsize
  sw      $s0, possibleCol($t1)         # possibleCol($t1) = col
  sw      $s1, possibleRow($t1)         # possibleRow($t1) = row
  addi    $s7, $s7, 1                   # n ++
  addi    $s4, $s4, 1                   # dy ++
  j       move_loop2                    # loop2

end2:
  addi    $s3, $s3, 1                   # dx ++
  j       move_loop1

end1:
  bne     $s7, 0, next               # if n == 0, return1
  li      $v0, 0                     # return 0
  jr      $ra

next:
  add     $t0, $s2, -1              # i = len -1
  ble     $t0, 0, end3              # loop
  add     $t1, $t0, -1              # t1 = i - 1
  mul     $t1, $t1, $t4             # t1 = (i-1) * intsize
  mul     $t2, $t0, $t4             # t2 = i * intsize
  move    $t3, wormRow($t1)         # t3 = wormRow[i - 1]
  sw      $t3, wormRow($t2)         # wormRow(i)  = t3

  add     $t1, $t0, -1              # t1 = i - 1
  mul     $t1, $t1, $t4             # t1 = (i-1) * intsize
  mul     $t2, $t0, $t4             # t2 = i
  move    $t3, wormCol($t1)         # t3 = wormCol[i-1]
  sw      $t3, wormCol($t2)         # wormCol[i] = t3
end3:
  move    $a0, $s7                  # a0 = n
  jal     randValue
  move    $t0, $v0                  # i = randValue(n)

  li      $t1, 0                    # t1 = 0
  move    $t2, possibleRow($t0)     # t2 = possibleRow[i]
  move    $t3, possibleRow($t0)     # t3 = possibleCol[i]

  sw      $t3, wormRow($t1)         # wormRow[0] = t2
  sw      $t2, wormCol($t1)         # wormCol[o] = t3
  li      $v0, 1                    # return 1
# tear down stack frame
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
  jr	$ra
