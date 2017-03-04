; Assignment 4
; Stefani Moore
; 106789878

; Write a program that takes input from the user to determine
; how many times to generate a random string.Each string generated
; should be unique.


Include Irvine32.inc

	L = 10; String length

.data

	prompt BYTE "Enter any integer greater than 0:", 0; For display message to user
	N DWORD ? ; for unsigned integer input from a user
	randomStringArray BYTE L DUP(0), 0; Array for random strings of length 10


.code
main proc

	mov eax, 0
	mov ecx, 0
	mov edx, 0

	call UserInt
	call RandStr

exit
main endp


; --------------------------------------------------------
;					UserInt Procedure
;
; Receives: N/A
; Returns: N - unsigned integers
; Requires: Input must be > 0
;
; ---------------------------------------------------------

UserInt proc

	mov edx, OFFSET prompt	; prompt index

	call WriteString		; displays prompt to user
	call Crlf				; new line
	call ReadInt			; reads user input

	mov N, eax				; user input stored in N
	ret						; return to main proc
UserInt endp				; End UserInt proc, pass user input in ECX

; --------------------------------------------------------
;					RandStr Procedure
;
; Receives: N, L - unsigned integers 
; Returns: EAX - string of random characters
; Requires: N - user input, L - Length of the string
;
; --------------------------------------------------------

RandStr proc

	mov ecx, N							; user defined number of random strings to generate
	mov ebx, L

L1:
	push ecx							; save outer loop count
	mov ecx, ebx						; loop counter = 10
	mov esi, OFFSET randomStringArray	; string index

L2:
	mov eax, 26							; generate int of 0 - 25
	call RandomRange					; generates random int in specified range
	add eax, 'A'						; range is 'A' to 'Z'
	mov[esi], al						; store the character at index esi
	inc esi								; increase index to next character position
loop L2									; end loop 2

	mov edx, OFFSET randomStringArray	; string index
	call randomColor					; calls procedure for random string colors
	call WriteString					; displays each string
	call Crlf							; new line
	pop ecx								; recover loop 1 counter
loop L1									; end loop 1
	ret									; return to main proc
RandStr endp

; --------------------------------------------------------
;					randomColor Procedure
;
; Receives: N/A
; Returns: EAX - integer of text color
; Requires: N/A
;
; --------------------------------------------------------

randomColor proc
	push eax			; save random character range
	mov eax, 15			; color range is 0 - 15
	call RandomRange	; generate random integer in range
	add eax, 1			; add one so 0 or black is not used
	call SetTextColor	; procedure called to set the string to the random color
	pop eax				; recover random character range
	ret					; return to RandStr proc
randomColor endp

end main

