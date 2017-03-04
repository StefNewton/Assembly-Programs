; PA3
;    a.Compute fib(n) for n = 2, 3, .. 6 using an array
;	 b.Store computed values in an array
;	 c.Store fib(3) - fib(6) in ebx reg.starting at lowest byte


; Stefani Moore
; 9.15.16


INCLUDE Irvine32.inc

.data

	ZERO_REG = 0

	; Fibonacci sequence = 0, 1, 1, 2, 3, 5, 8
fibW LABEL WORD
fibDW LABEL DWORD
fibArray BYTE 0, 1, 5 DUP(? )	; fib(0) = 0, fib(1) = 1, 5 uninitialized bytes follow



.code
main proc

; a.Compute fib(n) for n = 2, 3, .. 6 using an array

	; Zero registers
	MOV eax, ZERO_REG
	MOV ebx, ZERO_REG
	MOV ecx, ZERO_REG

	MOV esi, OFFSET fibArray	;index by size BYTE
	INC esi						; position 1 = 1
	MOV ecx, 5					; will loop for 5 iterations to calc fib(n) n=2,...,6

	top:						; begin loop

	MOV al, [esi]				; current position
	MOV bl, [esi - 1]			; previous postion
	ADD al, bl					; current + previous

; b.Store computed values in an array

	MOV[esi + 1], al			; put sum in next position of the array

	; Memory reads(1 - BYTE): 00 01 01 02 03 05 08

	INC esi						; Next index

	loop top					; loop starts back at top:

; c.Store fib(3) - fib(6) in ebx reg.starting at lowest byte

; MOV bl, [fibArray + 5]
;	MOV bh, [fibArray + 6]
;	MOV bh, esi
;	shl ebx, 16; shift register contents 16 bits left(found in appx.B)

; moves previous contents to the upper part of ebx

;	MOV bl, [fibArray + 3]
;	MOV bh, [fibArray + 4]

	;output: 08050302

	MOV bl, [fibArray + 3]
	MOV bx, fibW
	MOV ebx, fibDW

	call DumpRegs				; dump registers

	exit
main endp
end main