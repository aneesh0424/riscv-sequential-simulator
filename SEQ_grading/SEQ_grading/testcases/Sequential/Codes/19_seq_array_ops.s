addi x1, x0, 3
addi x2, x0, 7
addi x3, x0, 12
addi x4, x0, 5
addi x5, x0, 20
addi x6, x0, 15
addi x7, x0, 9
addi x8, x0, 11
sd x1, 0(x0)
sd x2, 8(x0)
sd x3, 16(x0)
sd x4, 24(x0)
sd x5, 32(x0)
sd x6, 40(x0)
sd x7, 48(x0)
sd x8, 56(x0)
addi x9, x0, 4
addi x10, x0, 8
addi x11, x0, 2
addi x12, x0, 10
addi x13, x0, 6
addi x14, x0, 14
addi x15, x0, 1
addi x16, x0, 18
sd x9, 64(x0)
sd x10, 72(x0)
sd x11, 80(x0)
sd x12, 88(x0)
sd x13, 96(x0)
sd x14, 104(x0)
sd x15, 112(x0)
sd x16, 120(x0)
addi x17, x0, 0
addi x18, x0, 64
addi x19, x0, 128
addi x20, x0, 64
ld x21, 0(x17)
ld x22, 0(x18)
add x23, x21, x22
sd x23, 0(x19)
addi x17, x17, 8
addi x18, x18, 8
addi x19, x19, 8
beq x17, x20, 8
beq x0, x0, -32
addi x17, x0, 0
addi x18, x0, 64
addi x19, x0, 192
ld x21, 0(x17)
ld x22, 0(x18)
sub x23, x21, x22
sd x23, 0(x19)
addi x17, x17, 8
addi x18, x18, 8
addi x19, x19, 8
beq x17, x20, 8
beq x0, x0, -32
addi x17, x0, 0
addi x18, x0, 64
addi x19, x0, 256
ld x21, 0(x17)
ld x22, 0(x18)
and x23, x21, x22
sd x23, 0(x19)
addi x17, x17, 8
addi x18, x18, 8
addi x19, x19, 8
beq x17, x20, 8
beq x0, x0, -32
addi x17, x0, 0
addi x18, x0, 64
addi x19, x0, 320
ld x21, 0(x17)
ld x22, 0(x18)
or x23, x21, x22
sd x23, 0(x19)
addi x17, x17, 8
addi x18, x18, 8
addi x19, x19, 8
beq x17, x20, 8
beq x0, x0, -32
addi x24, x0, 0
addi x25, x0, 128
addi x26, x0, 192
ld x27, 0(x25)
add x24, x24, x27
addi x25, x25, 8
beq x25, x26, 8
beq x0, x0, -16
addi x28, x0, 0
addi x25, x0, 192
addi x26, x0, 256
ld x27, 0(x25)
add x28, x28, x27
addi x25, x25, 8
beq x25, x26, 8
beq x0, x0, -16
ld x1, 128(x0)
ld x2, 136(x0)
ld x3, 144(x0)
ld x4, 152(x0)
ld x5, 192(x0)
ld x6, 200(x0)
ld x7, 208(x0)
ld x8, 216(x0)
ld x9, 256(x0)
ld x10, 264(x0)
ld x11, 272(x0)
ld x12, 280(x0)
ld x13, 320(x0)
ld x14, 328(x0)
ld x15, 336(x0)
ld x16, 344(x0)
sd x24, 384(x0)
sd x28, 392(x0)
ld x17, 160(x0)
ld x18, 168(x0)
ld x19, 176(x0)
ld x20, 184(x0)
ld x21, 224(x0)
ld x22, 232(x0)
ld x23, 240(x0)
ld x25, 248(x0)
ld x26, 288(x0)
ld x27, 296(x0)
add x29, x24, x28
sub x30, x24, x28
and x31, x24, x28
sd x29, 400(x0)
sd x30, 408(x0)
sd x31, 416(x0)
