  .text
delay:

# Frame:	$fp, $ra
# Uses: 	$a0
# Clobbers:	$t0, $t1, $t2

# Locals:
#	- `n' in $a0
#	- `x' in $f6
#	- `i' in $t0
#	- `j' in $t1
#	- `k' in $t2

# Code:
# set up stack frame
  sw	$fp, -4($sp)
  sw	$ra, -8($sp)
  la	$fp, -4($sp)
  addiu	$sp, $sp, -8

### TODO: your code goes here
  move    $s0, $a0            # s0 = n
  li      $f6, 3              # x = 3
  li      $t0, 0              # n = 0

d_loop1:
  bge     $t0, $s0, end_d1
  li      $t1, 0
d_loop2:
  bge     $t1, 40000, end_d2
  li      $t2, 0
d_loop3:
  bge     $t2, 1000, end__d3
  mul     $f6, $f6, 3
  add     $t2, $t2, 1
end_d3:
  add     $t1, $t1, 1
end_d2:
  add     $t0, $t0, 1
end_d1:
# tear down stack frame
  lw	$ra, -4($fp)
  la	$sp, 4($fp)
  lw	$fp, ($fp)
  jr	$ra


####################################
# seedRand(Seed) ... seed the random number generator
# .TEXT <seedRand>
