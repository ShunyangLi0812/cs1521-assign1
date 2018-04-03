.text
drawGrid:

# Frame:	$fp, $ra, $s0, $s1, $t1
# Uses: 	$s0, $s1
# Clobbers:	$t1

# Locals:
#	- `row' in $s0
#	- `col' in $s1
#	- `&grid[row][col]' in $t1

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -16

### TODO: Your code goes here

    li    $s0, 0          # row = 0
    li    $s2, 40         # NROWS = 40
    li    $s3, 20         # NCOLS = 20
    
    
loop11:
    bge   $s0, $s2, end_loop11
    li    $s1, 0          # col = 0
loop22:
    bge   $s1, $s3, end_loop2
    
    mul   $t1, $s0, $s3
    add   $t1, $t1, $s1
    lb    $a0, grid($t1)   # gird[row][col] = '.'
    li    $v0, 11
    syscall
    
    addi  $s1, $s1, 1      # col ++
    j     loop22
end_loop22:
    li    $a0, '\n'
    li    $v0, 11
    syscall
    
    addi  $s0, $s0, 1
    j     loop1
end_loop11:
	# tear down stack frame
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

