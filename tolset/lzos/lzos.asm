; just show welcome in the screen
; tab=4

	org	0x7c00			; org 伪指令指明装载地址0x7c00，定死的
	jmp	entry
	db 	0x90
	db 	"lzosload"		; 启动区的名称是任意的字符串，八个字节
	dw 	512			; 每个扇区的大小（必须为512），占用2个字节
	db	1			; 簇的大小（必须为一个扇区）
	dw	1			; FAT的起始位置
	db	2			; FAT的个数
	dw	224			; 根目录的大小
	dw	2880			; 该磁盘的大小
	db	0xf0			; 磁盘的种类
	dw	9			; FAT的长度
	dw	18			; 1个磁道有几个扇区
	dw	2			; 磁头数
	dd	0			; 不使用分区，必须是0
	dd	2880			; 重写一次磁盘大小
	db	0, 0, 0x29		; 意义不明，固定
	dd	0xffffffff		; 卷帙号码
	db	"lizhan-os  "		; 卷标 必须占据11个字节
	db	"FAT12   "		; 文件内容，必须占据8个字节

msg:	
	db	"Hello everybody. Welcome to my first OS !!"
	db	0

entry:	
	mov ax, 0
	mov ss, ax
	mov sp, 0x7c00
	mov ds, ax
	mov es, ax

	mov si, msg
welcome:
	mov al, byte ptr [si]
	cmp al, 0
	je done
	mov ah, 0x0e
	mov bx, 15
	int 10h
	inc si
	jmp welcome
done:	
	hlt
	jmp done

	RESB	(0x7c00 + 510) - $	; 第510个字节，511个字节，要特殊标记启动盘。中间的数据，预留填充占位
	DB	0x55, 0xaa	; fat12启动盘的标志:在510字节处标记0x55, 511字节处标记0xaa, 否则当数据盘对待
