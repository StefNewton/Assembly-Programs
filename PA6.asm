;// Assignment 6
;// Stefani Moore
;// 106789878

;// This program calculates all primes betwen 2 and 1000 or 2 and N
;// determined by the user.


INCLUDE Irvine32.inc						    ;// Include irvine libraries


.data

	;// Variables
	N DWORD ?								    ;//Used to hold user input variable
	totalPrimes BYTE 0							;//Track number of primes for range 2 through N

	;//Boolean array
	boolean TYPEDEF DWORD
	isPrime boolean 1000 DUP(1)					;//Boolean array of values from 2-1000 initialized to 1 or true

	;// For display
	dividerOutput BYTE "----------------------------------------------", 0

.code
main proc

	;// zero registers
	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 0
	MOV EDX, 0


	CALL MainMenu								;// Main menu procedure

	CALL WaitMSG								;// Pause program before exiting

exit
main endp


;// --------------------------------------------------------
;//					InputN Procedure
;//
;// Receives: N/A
;// Returns: Unsigned value for N, in EAX register
;// Requires: N/A
;//
;// Description: Asks the user for N, where N must be between
;//				 2 and 1000
;// ---------------------------------------------------------

InputN proc

.data
	;// prompt user for input
	msgN BYTE "Enter a number between 2 and 1000: ", 0

.code
	tryAgain:

		MOV EDX, OFFSET msgN					;// Offset for message to user
		CALL WriteString						;// display message
		CALL ReadInt							;// Read in integer input by user
		CMP EAX, 1000							;// compare integer input to 50

	JA tryAgain									 ;// Jump if eax(user input) is > 1000

		CMP EAX, 2

	JB tryAgain									;// Just if user input is < 2

		MOV N, EAX								;// move value of eax to N if value is between 2 and 1000
												;// N used for display of primes


		ret										;// return to mainMenu proc
InputN endp				

;// --------------------------------------------------------
;//					FindPrimes Procedure
;//
;// Receives: N for user input or N = 1000 for max range
;// Returns: 0 for non-primes and the prime number in the isPrime
;//			 array
;// Requires: N/A
;//
;// Description: Fills an array with all values from 2 to N. 
;//              Divides each value in the array by 2, 3, 4, and so on.
;//				 Checks for a remainder to determine if the # is prime.
;//				 0 in the remainder = non-prime, else # is a prime.							
;//
;// ---------------------------------------------------------

FindPrimes proc


		MOV ECX, 0								;//Zero ecx

	fillArr:									;//Fill the array isPrime with all values from 2 to N

		MOV EAX, ECX
		ADD EAX, 2								;//range starts at 2
		MOV [isPrime + 4 * ECX], EAX			;//Put each number into an element of the array
		INC ECX									;//increment to next element in the array
		CMP ECX, N								;// continue while ecx < User input N

	JB fillArr

;//The below algortihm divides each number in the array (incremented by EBX) by 2, 3, 4, and so on (inc. by ECX)
;// until only prime numbers are left in the array. All non-prime numbers are represented by 0 

		MOV ECX, 0								;// zero ecx
	L1:
		MOV EBX, ECX
		INC EBX									;//increment EBX
		CMP[isPrime + 4 * ECX], 0				;//ECX multiplied by 4 to increment to next DWORD element

	JNE L2										;//If not equal to zero jump to L2

	increaseECX:								;// After iterating through all numbers 2-N in the array increment ECX for division

		INC ECX
		CMP ECX, N								;// Only continue while ECX < user input N or 1000

	JB L1										;// If still < N jump back to L1

	JMP bottom									;// if > N jump to the bottom of the proc

	L2:

		CMP[isPrime + 4 * EBX], 0
	JNE L3										;// If element is not equal to 0 jump to L3 to check if it is prime

	IncreaseEBX:								;// Move to next element in the array

		INC EBX
		CMP EBX, N								;// Only increase while EBX < N, once N is reached jump to IncreaseECX to check for numbers divisible by element in ECX offset

	JB L2										;//If EBX is still < N jump to L2 loop

	JMP increaseECX

	L3 :										;//if array element is not = to 0
		MOV EDX, 0								;// zero register
		MOV EAX, 0								;// zero register

		MOV EAX, [isPrime + 4 * EBX]			;//Move current array element into EAX
		DIV[isPrime + 4 * ECX]					;//Divide element in EAX by number at ECX offset in the array
		CMP EDX, 0								;// If remainer is = 0, then then the number is not a prime. Else, JMP to IncreaseEBX

	JE deleteIt									;//If = 0, number is not a prime. Replace the number with a 0
		
	JMP IncreaseEBX							
		
	deleteIt:

		MOV[isPrime + 4 * EBX], 0				;//Replace non-prime number with a 0

	JMP IncreaseEBX								;//increase EBX to next array element 

			
	bottom:

		 ret									;// return to mainMenu proc
FindPrimes endp

;// --------------------------------------------------------
;//					DisplayPrimes Procedure
;//
;// Receives: N for max range of user input or 1000, 
;//			  Array filled with calculated primes
;// Returns:  N/A
;// Requires: N/A
;//
;// Description: Displays all calculated primes and the total
;//				# of primes for any range 2 through N
;//				 
;// ---------------------------------------------------------

DisplayPrimes proc

.data

		;// Messages to user
		thereAre BYTE "There are ", 0
		primeNumber BYTE " primes between 2 and n (n = ", 0
		endParenthesis BYTE ")", 0

		;//row and col used for GoToXY cursor location to create columns of numbers
		row BYTE 2
		col BYTE 0

		;//temp is used to keep track of how many primes are printed per row so that it can be limited to 5
		temp BYTE 0

.code

		SUB N, 1
		MOV ECX, N								;// Set loop counter to N-1
		MOV EBX, 0								;//zero register

;//Below loop is used to determine the total number of primes for any given range of 2 through N
	L1:

		MOV EAX, [isPrime + 4 * EBX]			;//Move array element into EAX register

		CMP EAX, 0								;//Compare to zero

	JNE numIsPrime								;//If the number is not = 0, then it is a prime number

		INC EBX									;//increment EBX

	JMP endL									;//Jump to the end of the loop 

	numIsPrime:

		INC totalPrimes							;//If number is prime increase totalPrimes
		INC EBX									;//Incremenet EBX to next element in the array

	endL:

	loop L1


		CALL clrscr								;// clear screen

		;//Display prompts for calculated prime numbers
		MOV EDX, OFFSET thereAre
		CALL WriteString

		MOV AL, totalPrimes
		CALL WriteDec

		MOV EDX, OFFSET primeNumber
		CALL WriteString

		ADD N, 1

		MOV EAX, N								;// (n = N)
		CALL WriteDec

		SUB N, 1

		MOV AL, endParenthesis
		CALL WriteChar
		CALL crlf								;// new line
		
		MOV EDX, OFFSET dividerOutput
		CALL WriteString
		CALL crlf								;// new line


		MOV EBX, 0								;// zero register


	;// The below loops display each prime number with a max of 5 elements per row and 5 spaces between each column
	displayElement:

		MOV EAX, [isPrime + 4 * EBX]			;//Move element into EAX
		CMP EAX, 0								;//Check to see if the number is a prime or non-prime number

	JE elementIsZero							;//If element is 0, then not a prime

		;//Below executed if the number is prime
		MOV DH, row								;//Move cursor location to just below the previous prompt and at col 0
		MOV DL, col
		CALL GoToXY

		CALL WriteDec							;//Write prime number to output
		INC temp								;//Will print to the same row while temp < 5
		CMP temp, 5

	JE equal5

		;//Temp is < 5
		ADD col, 5								;//create 5 spaces between each printed prime number
		INC EBX									;// move to next array element

	JMP bottom									;//JMP to the bottom of the loop 

	equal5:										;// If temp is 5, meaning 5 elements have been printed to the row, execute the following

		CALL crlf								;//move to next line
		SUB col, 25								;//Move cursor back to col 0
		INC row									;//move cursor to next row
		MOV temp, 0								;// reset temp variable to 0

		MOV DH, row								;//Call function to set cursor location
		MOV DL, col
		CALL GoToXY

		ADD col, 5								;//Add 5 spaces between each col
		INC EBX									;// Increment to next array element

	JMP bottom									;// JMP to the bottom of the loop

	elementIsZero:								;//element was zero

		INC EBX									;//If number was non-prime, skip to next element in the array

	bottom:

		CMP EBX, N								;// Continue loop while EBX < N

	JB displayElement


		;// Reset all variables to appropriate values
		;// If user chooses to run another prime # calculation all variables will be at the correct starting point
		MOV col, 0
		MOV row, 2
		MOV temp, 0
		mov totalPrimes, 0

		CALL crlf								;// new line
		CALL waitMSG							;// pause before pulling up new main menu

		ret										;// return to mainMenu proc
DisplayPrimes endp

;// --------------------------------------------------------
;//					MainMenu Procedure
;//
;// Receives: N / A
;// Returns: N / A
;// Requires: N / A
;//
;// Description: This procedure provides a menu and requires
;// the user to make a selection. It then calls other
;// program prodecures to calculate all of the prime numbers
;// between 2 and n or 2 and 1000
;//
;// --------------------------------------------------------

MainMenu proc
.data

		;// User prompts for main menu
		mainMenuDisplay BYTE "Main Menu", 0
		menuOpt1 BYTE "1. Display all primes between 2 and 1000", 0
		menuOpt2 BYTE "2. Display all primes between 2 and n", 0
		menuOpt3 BYTE "3. Exit", 0

.code
	top:
		CALL clrscr								;// clear screen
		MOV EDX, OFFSET mainMenuDisplay			;// Menu prompt
		CALL WriteString
		CALL crlf

		MOV EDX, OFFSET dividerOutput			;// menu divider
		CALL WriteString
		CALL crlf

		MOV EDX, OFFSET menuOpt1				;// Menu option 1 display
		CALL WriteString
		CALL crlf

		MOV EDX, OFFSET menuOpt2				;// Menu option 2 display
		CALL WriteString
		CALL crlf

		MOV EDX, OFFSET menuOpt3				;// Menu option 3 display
		CALL WriteString
		CALL crlf

		CALL ReadInt							;// Read in integer

		CMP EAX, 3								;// compare EAX to 3

	JE exitProg									;// If user enters 3 jump to exitProg

	JA top										;// If user enters # > 3 jump back to the top to repeat the menu process until valid entry is input

		CMP EAX, 2

	JNE userPicks1								;// if EAX != 2, user picked 1

		;// User picked 2
		CALL inputN								;//Get user defined range for 2 through N
		CALL FindPrimes							;// calculate primes for the range 2 through N
		CALL DisplayPrimes						;// Display primes

	JMP top

	userPicks1:

		CMP EAX, 1

	JB top										;// If user entry is < 1, jump back to the top to repeat the menu process until valid entry is input

		;// User picked 1
		MOV N, 1000								;//Range is 2 through N = 1000
		CALL FindPrimes							;// Calculate primes for the range 2 through 1000
		CALL DisplayPrimes						;// Display all primes

	JMP top										;// repeat menu until 3 is entered

	exitProg:

		exit									;// exit program
	
	ret 
MainMenu endp
end main

