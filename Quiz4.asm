
;// Quiz 4
;// Stefani Moore
;// 106789878

;// This program generates up to 25 random ints between 50 and 100 inclusively.
;// Depending on user input, calculates the letter grade and prints the integer and the letter grade


INCLUDE Irvine32.inc						; // use irvine libraries

.data

	ArrayD DWORD 25 DUP(?)					;// ArrayD, 25 elements initialized to ?
	DefaultColor = lightGray + (black * 16)	;//Default color scheme

.code

main proc

	call userint1							;// Gets number from the user, returns the number in eax register

	mov ebx, OFFSET ArrayD					;// ArrayD offset to ebx register
	call AlphaGrade							;// returns a letter grade between 0 and 100

	mov ebx, OFFSET ArrayD					;//ArrayD offset to ebx register
	call PrintGrade							;//prints the randomly generated integer and resulting letter grade

	mov eax, DefaultColor					;//set text to default before exiting the program
	call SetTextColor

	call waitMSG							;//Pause program before exiting

exit
main endp

;//***************************************************************************
;// userint1
;// Receives user input, continues loop if > 25, exits if 0
;// Stores input in eax if between 0-25
;//***************************************************************************
userint1 proc

	.data
		prompt BYTE "Enter a number between 0 and 25, or 0 to exit: ", 0

	.code
		mov edx, OFFSET prompt

	askUser:
		call WriteString
	

		call ReadDec
		cmp eax, 25
		ja askUser
		cmp eax, 0
		je exitProg


		ret

	exitProg:
	exit

userint1 endp

;//***************************************************************************
;//AlphaGrade 
;// Inputs
;// offset of ArrayD in ebx
;// numbers to generate in eax
;//***************************************************************************

AlphaGrade proc
	.data

		par1 = '('
		par2 = ')'
		gradeA = 'A'					;//21h, 33d
		gradeB = 'B'					;//22h, 34d
		gradeC = 'C'					;//23h, 35d
		gradeD = 'D'					;//24h, 36d
		gradeF = 'F'					;//26h, 38d

	.code

			mov edx, 0
	
			mov ecx, eax				;// Move user entered value into loop counter ecx

			push eax	
			call Randomize				;// Randomize values

	L1:									;//begin loop
			mov eax, 51
			call RandomRange			;//generate random number
			add eax, 50

			cmp eax, 59d				;// 3Bh = 59d
		JA greaterThan59				;//jump if > 59

			shl eax, 8					;// integer grade will be in bits 8-15 of ArrayD

			mov edx, gradeF				;//the grade is an F if < 59
			call PutIntoArray

			JMP BTM						;//Jump to bottom if number is < 59

		greaterThan59:
			cmp eax, 69d				;// 45h = 69d
		JA greaterThan69				;//Jump if > 69

			shl eax, 8					;// integer grade will be in bits 8-15 of ArrayD

			mov edx, gradeD				;//the grade is an D if < 69, , but > 59
			call PutIntoArray

			JMP BTM

		greaterThan69:
			cmp eax, 79d				;// 4Fh = 79d
		JA greaterThan79

			shl eax, 8					;// integer grade will be in bits 8-15 of ArrayD

			mov edx, gradeC				;//the grade is an C if < 79, , but > 69
			call PutIntoArray

			JMP BTM

		greaterThan79:
			cmp eax, 89d				;// 59h = 89d, 00 added for bit position 8-15
		JA greaterThan89

			shl eax, 8					;// integer grade will be in bits 8-15 of ArrayD

			mov edx, gradeB				;//the grade is an B if < 89, but > 79
			call PutIntoArray

			JMP BTM

		greaterThan89:
			
			shl eax, 8					;// integer grade will be in bits 8-15 of ArrayD

			mov edx, gradeA				;//the grade is an A if > 89
			call PutIntoArray
		
			BTM:
			add ebx, 4					;//increment to next DWORD element

		loop L1							;//loop
			pop eax
		
			ret
AlphaGrade endp


;//***************************************************************************
;//PrintGrade 
;//inputs
;//ArrayD offset in ebx
;//***************************************************************************

PrintGrade proc
	.data
			int1 BYTE 1					;//For row of GoToXY function call
			int2 BYTE 3					;//For col of GoToXY function call

			par1 = '('					;//Used to print letter grade in the format - (A), (B), etc.
			par2 = ')'
	.code
			mov edx, 0					;//zero register
			mov ecx, eax				;// loop counter

	L2:
	
			mov edx, [ebx]
			shr edx, 8					;//move letter grade into dl range 
			mov al, dl					;//move dl into al for WriteDec
			call WriteDec				;//prints integer grade
			push edx

			cmp al, 100
		JE is100
			mov dh, int1				;//For row
			mov dl, int2				;//For col
			call GoToXY					;//Move cursor position to previous row/col

			inc int1					;//increment to next row
			add int2, 5					;//create 5 spaces between integer grade and letter grade
			JMP contProgram

		is100 :							;// Creates a space for the scenario if the grade is 100
			mov dh, int1
			mov dl, int2
			add dl, 1					;// Moves one more column over before adding 5 spaces to account for 100
			call GoToXY

			inc int1
			add int2, 5
			JMP contProgram

		contProgram:
			pop edx

			mov al, par1
			call WriteChar				;//write '(' opening parenthesis

			shr edx, 8					;//move letter grade to dl range


			call setColor				;//Set grade color and print letter grade

			mov al, par2
			call WriteChar				;//write ')' closing parenthesis

			call crlf					;//new line

			add ebx, 4					;//increment to next DWORD element
			sub int2, 5					;//subtract 5 to go make to beginning col position

	loop L2

			ret
PrintGrade endp

;//***************************************************************************
;//setColor
;//inputs
;//edx (dl specifically) contains char letter grade in hex
;//writes character to screen in a color dependent on that letter grade
;//***************************************************************************

setColor proc

	.data
			;//Colors for printing the grade
			GreenOnBlack = green 
			YellowOnBlack = yellow 
			BlackOnYellow = black + (yellow * 16)
			RedOnBlack = red 
			Default = lightGray

	.code

			mov eax, 0
			cmp dl, 'B'
		JA gradeBelow79						;//Jump if letter grade is higher than a B, which is lower than a 79

			mov eax, GreenOnBlack
			call SetTextColor

			mov al, dl						;//move dl to al for WriteChar
			call WriteChar					;// write letter grade
			JMP bottom

		gradeBelow79:
			cmp dl, 'C'
		JA gradeBelow69						;//Jump if letter grade is higher than a C, which is lower than a 69

			mov eax, YellowOnBlack
			call SetTextColor
			mov al, dl						;//move dl to al for WriteChar
			call WriteChar					;// write letter grade
			JMP bottom

		gradeBelow69:

			cmp dl, 'D'
		JA gradeBelow59						;//Jump if letter grade is higher than a D, which is lower than a 59

			mov eax, BlackOnYellow
			call SetTextColor
			mov al, dl						;//move dl to al for WriteChar
			call WriteChar					;// write letter grade
			JMP bottom

		gradeBelow59:

			mov eax, RedOnBlack
			call SetTextColor

			mov al, dl						;//move dl to al for WriteChar
			call WriteChar					;// write letter grade

		bottom:

			mov eax, Default
			call SetTextColor
				
			ret
setColor endp

;//***************************************************************************
;//PutIntoArray
;//inputs
;//ArrayD offset in ebx, integer grade in eax, letter grade in edx
;//shifts letter grade left 16 and add to integer grade in eax to input into
;//Dword element of ArrrayD
;//***************************************************************************

PutIntoArray proc


			shl edx, 16						;// char letter grade will be in bits 0-7 of ArrayD
			add eax, edx
			mov[ebx], eax					;//Move letter and integer grade into ArrayD DWORD element

			ret
PutIntoArray endp

end main