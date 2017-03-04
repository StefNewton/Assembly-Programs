; PA3
; Write an assembly program that accomplishes the following:
; 1. Rearrange the values of arrayD DWORD 178d, 18d, 211d into this order: 18d, 178d, 211d
;	 Use only MOV and XCHG to accomplish the result

; Stefani Moore
; 9.15.16


INCLUDE Irvine32.inc

.data

	arrayD DWORD 178d, 18d, 211d; Locations: 0, 4, 8 - HEX : B2h 12h D3h
	ZERO_REG = 0

.code
main proc

; Requirement 1: Rearrange the values of arrayD DWORD 178d, 18d, 211d into this order : 18d, 178d, 211d
;				 memory with original array order reads : 000000B2h  00000012h  000000D3h (4-BYTE integer)

	MOV eax, ZERO_REG		; Zero register

	;Performing element exchange

	MOV eax, [arrayD + 4]	; 18d or 12h moves into eax register for temp storage
	XCHG eax, [arrayD]		; exchange value of eax with 178d or B2h
	MOV[arrayD + 4], eax	; 178d or B2h moves into array offset position 4


	MOV eax, arrayD			; move new ordered array into eax

	call DumpRegs			; dump registers; memory now reads: 00000012h 000000B2h 000000D3h (4-BYTE integer)



	exit
main endp
end main