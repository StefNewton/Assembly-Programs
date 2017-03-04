; Assignment 5
; Stefani Moore
; 106789878

; Write a program to print an array of randomly generated numbers in
; a random color(yellow, blue, or red) as selected by RandomColor.


Include Irvine32.inc


.data

; Variables
	N DWORD ?
	j DWORD ?
	k DWORD ?

;Array of DWORDs that is 50 elements long
	randArray DWORD 50 DUP(0)

; Messages to user
	msgN BYTE "Enter a number less than 50: ", 0
	msgj BYTE "Enter lower range: ", 0
	msgk BYTE "Enter upper range: ", 0
	errorN BYTE "Value > 50. Enter another Number: ", 0
	errorJ BYTE "j is not < k. Enter another low range: ", 0
	errorK BYTE "j is not < k. Enter another upper range: ", 0
	arrayContents BYTE "Contents of Array: ", 0
	menuSelect BYTE "Select one of the menu options below", 0
	menuOpt1 BYTE "1) Print Randomly Generated Arrays", 0
	menuOpt2 BYTE "2) Repeat", 0
	menuOpt3 BYTE "3) Quit", 0
	menuError BYTE "Please input a valid menu option", 0

.code
main proc

; zero registers
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0

	call MainMenu ; Main menu procedure

exit
main endp


; --------------------------------------------------------
;					GetInputFromUser Procedure
;
; Receives: N/A
; Returns: Unsigned values for N, j and k.
; Requires: N/A
;
; Description: Asks the user for N, j and k.N must be < 50
;			   and j must be < k. 
;
; -------------------------------------------------------- -

GetInputFromUser proc

	mov edx, OFFSET msgN ; Offset for message to user
	call WriteString ; display message
	call ReadInt ; Read in integer input by user
	cmp eax, 50 ; compare integer input to 50

JA getN ; Jump if eax(user input) is > 50

	mov N, eax ; move value of eax to N
	JMP nextStep ; Jump to next step if input is < 50

; user input was greater than 50
getN:

	mov edx, OFFSET errorN ; display error message
	call WriteString
	call ReadInt ; Read in integer input by user
	cmp eax, 50 ; compare integer input to 50

JA getN ; Will continue jumping until a number <= 50 is entered


nextStep : 
	mov N, eax ; Move eax to N

	mov edx, OFFSET msgj ; Display message for j
	call WriteString ;
	call ReadInt ; Read in integer
	mov j, eax ; move eax to j

	mov edx, OFFSET msgk ; display message for k
	call WriteString ;
	call ReadInt ; read in integer
	
	cmp j, eax ; compare j to value input for k

JAE getNewJK ; if j >= k

	mov k, eax ; move eax to k

JMP nextStep2 ;

; 
getNewJK:
		
	mov edx, OFFSET errorJ ; display error message for j
	call WriteString 
	call ReadInt ; read in integer for j

	mov j, eax ; move eax to j

	mov edx, OFFSET errorK ; display error message for k
	call WriteString 
	call ReadInt ; read in integer for k

	cmp j, eax ; compare j to eax

JA getNewJK ; Jump if j is > k

;If j < k move to next step
nextStep2:
	mov k, eax ; move eax to k

	ret						; return to main proc
	GetInputFromUser endp				

; --------------------------------------------------------
;					FillTheArray Procedure
;
; Receives: N, j and k
; Returns: randArray
; Requires: valid input for N, j and k
;
;
; Description: Fills an array of size N with random ints.
; The random ints. are between the range j-k.
;
; --------------------------------------------------------

FillTheArray proc

	mov ecx, N; move N input value to ecx loop counter
	mov eax, 0; zero register
	mov esi, 0; zero register
	mov esi, OFFSET randArray; pointer to array

; Loop 1 generates random integers in the range of j-k
L1:
	mov eax, k
	sub eax, j
	call RandomRange

	add eax, j
	mov[esi], eax
	add esi, 4

loop L1

	mov edx, OFFSET arrayContents ; Display message for array contents
	call WriteString
	call crlf

	mov esi, 0
	mov esi, OFFSET randArray
	mov ecx, N

; Loop 2 displays array contents in red, blue, or yellow colors
L2:
	mov eax, [esi]
	call RandomColor
	call WriteInt
	call crlf

	add esi, 4

loop L2


	ret									; return 
	FillTheArray endp

; --------------------------------------------------------
;					RandomColor Procedure
;
; Receives: N/A
; Returns: Text set to a color
; Requires: N/A
;
;
; Description: Randomly generates an int.between 0 - 9.
; based on random int. generated the text will be set to
; either a blue, red, or yellow color.
;
; --------------------------------------------------------

RandomColor proc

	push eax; save random integer range
	mov eax, 10; color range is 0 - (10 - 1)
	call RandomRange; generate random integer in range

	cmp eax, 3; compare random number to 3


JNE notEqual; If random number is not equal to 3
	; It is equal to 3
	mov al, 4
	call SetTextColor

	JMP bottom ; If eax is equal to 3 jumpt to bottom

	notEqual: ; if eax is not equal to 3

	JB lessThan3 ; If eax is less than 3 jump to lessThan3

	; greater than 3
	mov al, 1
	call SetTextColor

	JMP bottom ; Jump to bottom if eax is greater than 3

;If eax is < 3
lessThan3:

	mov al, 14;
	call SetTextColor;


bottom:

	pop eax				; recover random integer range
	ret					; return
RandomColor endp

; --------------------------------------------------------
;					MainMenu Procedure
;
	; Receives: N / A
		; Returns: N / A
		; Requires: N / A
;
	; Description: This procedure provides a menu and requires
		; the user to make a selection.It then calls other
		; program prodecures to fill and / or print an array
		; of random Ints. or exits the program
;
	; --------------------------------------------------------

MainMenu proc
		
top:
	; Set text to color so that menu is not the previous array color
		mov al, 15
		call SetTextColor
		mov eax, 0

		mov edx, OFFSET menuSelect; Menu prompt
		call WriteString
		call crlf

		mov edx, OFFSET menuOpt1; Menu option 1 display
		call WriteString
		call crlf

		mov edx, OFFSET menuOpt2; Menu option 2 display
		call WriteString
		call crlf

		mov edx, OFFSET menuOpt3; Menu option 3 display
		call WriteString
		call crlf

		call ReadInt; Read in integer

		cmp eax, 3 ; compare eax to 3

JA notValid ; Jump if eax > 3

	JBE validOption1 ; Jump if eax <= 3

	validOption1:

		cmp eax, 1

	JAE validOption2 ; If eax >= 3

		mov edx, OFFSET menuError ; Invalid input display
		call WriteString
		call crlf

		jmp top

	validOption2:
		cmp eax, 2;
			
	JNE not2;

		call FillTheArray;
		jmp top;
			
	not2:

	JA exitP ; jump if eax > 3

		call GetInputFromUser
		call FillTheArray

		jmp top
			
	notValid:

		mov edx, OFFSET menuError
		call WriteString
		call crlf

		jmp top

			
	exitP:

	ret ; return
	MainMenu endp
end main

