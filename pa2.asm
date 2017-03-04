; PA2
; Write an assembly program that accomplishes the following:
; 1. Compute the product of i = 2 to 8 of capital pi
; 2. Write a short block of statements that overflows the BX register
; 3. Write a short block of statements that overflows the CX register
; 4. Write a single statement that computes the number of seconds in a day
; 	and puts it in the EDX register


; Stefani Moore
; 9.7.16


INCLUDE Irvine32.inc

.data

ZERO_REGISTER = 0
SECONDS_IN_DAY = 24d * 60d * 60d; Seconds in day calculation

sum  DWORD 0; sum of i = 2 to 8 of capital pi
var1 SWORD 0111000000000000b; signed variable = 28672d
var2 SWORD 0101000000000000b; signed variable = 20480d
sum2 SWORD 0; signed sum for overflow of bx and cx


.code
main proc

	; Requirement 1: Compute product of i = 2 to 8 of capital pi and place in EAX register
	mov eax, ZERO_REGISTER
	mov	eax, 2d * 3d * 4d * 5d * 6d * 7d * 8d; = 40320d 
	mov	sum, eax
	call DumpRegs; dump registers

	; Requirement 2: Short block of code that causes the bx register to overflow
	mov ebx, ZERO_REGISTER
	mov bx, var1
	add bx, var2; overflow flag = 1
	mov sum2, bx
	call DumpRegs; dump registers
	sub bx, bx; Clears the overflow flag so it can be set again for requirement 3

	; Requirement 3: Short block of code that causes the cx register to overflow
	mov ecx, ZERO_REGISTER
	mov cx, var1
	add cx, var2; overflow flag = 1
	mov sum2, cx
	call DumpRegs; dump registers

	; Requirement 4: Computes the number of seconds in a day and is placed in EDX register
	mov edx, ZERO_REGISTER
	mov edx, SECONDS_IN_DAY ;  Seconds in day result passed to edx register
	call DumpRegs ; dump registers


	exit
main endp
end main