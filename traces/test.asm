store:
addi x5, x0, 5
sw x5, 0(x3)
sw x5, 4(x3)
addi x5, x0, 0x19
sw x5, 8(x3)
lui x5, 0x12511
srli x5, x5, 12
sw x5, 12(x3)
addi x5, x0, 0x28
sw x5, 16(x3)
lui x5, 0x7ecb
srli x5, x5, 12
lui x6, 0x06190
add x5, x6, x5
sw x5, 20(x3)

setup:
lw x12, 0(x3)
lw x8, 4(x3)
jal x1, main
lw x12, 8(x3)
lw x8, 12(x3)
jal x1, main
lw x12, 16(x3)
lw x8, 20(x3)
jal x1, main
addi x10, x0, 1
addi x11, x0, 1
jal x0, stop

main:
addi x26, x1, 0
jal x1, fib
sub x5, x8, x12
sub x6, x8, x13
sltiu x28, x5, 1
sltiu x29, x6, 1
or x30, x29, x28
beq x30, x0, stop
addi x1, x26, 0
jalr x0, 0(x1)

fib:
addi x5, x0, 0
addi x6, x0, 1
addi x7, x0, 1
loop:
bge x7, x12, return
add x5, x5, x6
addi x7, x7, 1
bge x7, x12, return
add x6, x5, x6
addi x7, x7, 1
j loop
return:
add x12, x0, x5
add x13, x0, x6
jalr x0, 0(x1)

stop:
addi x0, x0, 0