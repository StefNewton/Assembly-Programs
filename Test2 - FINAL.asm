; Test 2 - Code
; Stefani Moore
; 106789878

; Simple game of hangman.A random string from 14 words will be selected
; for the user to try and guess.They will get 10 guesses to win the game.
; The user will be able to guess a letter or a word and with lowercase or
; uppercase letters.


Include Irvine32.inc



.data

	dashArray BYTE "__________", 0h				;// Array of dashes used for hangman output
	winVar BYTE 0								;//used like a bool variable. Will equal 1 once all characters are matched
	gameCount DWORD	0							;//Used to track the number of games played
	winCount DWORD 0							;//Tracks the number of wins
	loseCount DWORD 0							;//Tracks the number of losses
	numOfMatches DWORD 0						;//Tracks the number of letter matches between a user guess and the given word

.code
	main proc

	call gameRules								;// Displays game rules

begin:	
												;//Loops back to this point if the user wants to play another game
	cmp gameCount, 1							;//If more than 1 game has been played. The dash array needs to be changed
												;//back to only dashes
JB continueGame

	call fixArray								;//Fixes the dashArray back to only dashes

continueGame:									;//IF it is the first game, then skip fixArray proc call

	;//Zero registers
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	mov esi, 0
	mov edi, 0


	mov winVar, 0								;//Reset winVar to 0
	mov numOfMatches, 0							;//Reset number of matches to 0

	call getWord								;//generates random word for user to guess
	call userGuess								;//prompts user for type of guess and makes functions calls based on choice

	add gameCount, 1							;//keeps track of number of games played
	call playAgain								;//Prompts the user to determine if they would like to play again

	cmp al, 'Y'									;//If the user enters y, then the game is ran again
	
JE begin										;//Loop to the beginning of main

	call endGamePromptDisplay					;//if user decides not to play another game prompt with number of
												;// wins, losses, and games played
	call waitMsg								;// pause the program before exiting 
exit
main endp

;// --------------------------------------------------------
;//					gameRules Procedure
;//
;// Receives: N/A
;// Returns: N/A
;// Requires: N/A
;//
;// Description: Displays game rules, then clears screen once
;//				 the user presses enter
;//
;// ----------------------------------------------------------

gameRules proc

.data
	rule1 BYTE "-------------------HANG MAN GAME------------------", 0Dh, 0Ah,0h
	rule2 BYTE "Your goal is to guess the word whose size is", 0Dh, 0Ah, 0h
	rule3 BYTE "indicated by the number of dashes. You must figure", 0Dh, 0Ah,0h
	rule4 BYTE "out this word in 10 guesses or less to win. Good Luck!",0Dh, 0Ah, 0h

.code

	mov edx, OFFSET rule1
	call WriteString
	mov edx, OFFSET rule2
	call WriteString
	mov edx, OFFSET rule3
	call WriteString
	mov edx, OFFSET rule4
	call WriteString

	call waitmsg								;//press enter to continue
	call clrscr									;//clear screen

ret; return to main proc
gameRules endp; End gameRules proc

;// --------------------------------------------------------
;//					playAgain Procedure
;//
;// Receives: N / A
;// Returns: Char 'Y' or 'N' in AL of EAX register
;// Requires: N / A
;//
;// Description: Prompts user to see if they want to play again
;//			    any character is converted to uppercase and 
;//				if y or n, Y or N is not enterered, then it
;//				will continue to loop until they are 
;//
;// ----------------------------------------------------------

playAgain proc
.data

	playAgainPrompt BYTE "Do you wish to play again (Y/N) ", 0h

.code

TOP :
	mov edx, OFFSET playAgainPrompt				;//Display prompt
	call WriteString
	call readChar								;//User enters char
	call writeChar								;//Displays entered character
	call crlf									;// new line

	and al, 0DFH								;// makes lowercase char uppercase

	cmp al, 'Y'									;//error check for valid input

JE BTM

	cmp al, 'N'

JNE TOP

BTM:
	call clrscr									;//clear screen
ret
playAgain endp

;// --------------------------------------------------------
;//					endGamePromptDisplay Procedure
;//
;// Receives: gameCount, winCount, loseCount
;//			  
;// Returns: n / A
;// Requires: N / A
;//
;// Description: Displays end of game prompt with number of 
;//				games plays, number of wins, and num of losses
;//			     
;//
;// ----------------------------------------------------------

endGamePromptDisplay proc

.data

	;//Prompts
	numGames BYTE "Number of Games Played: ", 0h
	numWins BYTE "Number of Wins: ", 0h
	numLosses BYTE "Number of Losses: ", 0h
	endGamePrompt BYTE "Thanks for playing!", 0Dh, 0Ah, 0h

.code

	call crlf									;// new line

	mov edx, OFFSET numGames					;//display number of games
	call WriteString
	mov eax, gameCount
	call WriteDec
	call crlf

	mov edx, OFFSET numWins						;// display number of wins
	call WriteString
	mov eax, winCount
	call WriteDec
	call crlf

	mov edx, OFFSET numLosses					;//display number of losses
	call WriteString
	mov eax, loseCount
	call WriteDec
	call crlf


	mov edx, OFFSET endGamePrompt				;//thanks for playing prompt
	call WriteString


ret
endGamePromptDisplay endp

;// --------------------------------------------------------
;//					fixArray Procedure
;//
;// Receives: EDI - dashArray offset
;// Returns: dashArray with all '_' characters
;// Requires: N / A
;//
;// Description: If the user chooses to play more than one
;//			    game, then the array is set back to only '_'
;//				characters
;//
;// ----------------------------------------------------------

fixArray proc

	mov edi, OFFSET dashArray

	mov ecx, 10
L1:
	mov al, '_'
	mov[edi], al
	inc edi

loop L1

ret
fixArray endp

;// --------------------------------------------------------
;//					getWord Procedure
;//
;// Receives: N / A
;// Returns: Word OFFSET in ESI and LENGTHOF word in EBX
;// Requires: N / A
;//
;// Description: Uses Random32 to generate large integer #.
;//			    the # is divided by 14 and the remainder is
;//				used to determine which word is used. The word
;//				offset is passed in ESI and length in EBX.
;//
;// ----------------------------------------------------------

getWord proc
.data

	String0 BYTE "RACE", 0h
	String1 BYTE "CANOE", 0h
	String2 BYTE "DOBERMAN", 0h
	String3 BYTE "FRAME", 0h
	String4 BYTE "HAWSE", 0h
	String5 BYTE "ORANGE", 0h
	String6 BYTE "FRIGATE", 0h
	String7 BYTE "KETCHUP", 0h
	String8 BYTE "POSTAL", 0h
	String9 BYTE "BASKET", 0h
	String10 BYTE "CABINET", 0h
	String11 BYTE "BIRCH", 0h
	String12 BYTE "MACHINE", 0h
	String13 BYTE "FIANCE", 0h



.code
	mov esi, 0							;//zero register

	call Randomize						;//generate random seed
	call Random32						;//One random integer of any size

	mov edx, 0							;// for EDX:EAX division to prevent stack overflow
	mov ebx, 14							;//to divide by 14
	div ebx								;// remainder will be in EDX register

	cmp edx, 6							;//using binary search method by starting in the middle and then looking at each half

JB lowerHalf
JA upperHalf

	;//Remainder = 6
	mov esi, OFFSET String6
	mov ebx, LENGTHOF String6

JMP BOTTOM

lowerHalf :

	cmp edx, 3

JB lowerBotQuarter
JA lowerUpQuarter

	;//Remainder = 3
	mov esi, OFFSET String3
	mov ebx, LENGTHOF String3

JMP BOTTOM

lowerBotQuarter :

	cmp edx, 1

JB remainder0
JA remainder2

	;//Remainder = 1
	mov esi, OFFSET String1
	mov ebx, LENGTHOF String1

JMP BOTTOM

remainder0 :
	;//Remainder = 0
	mov esi, OFFSET String0
	mov ebx, LENGTHOF String0

JMP BOTTOM

remainder2 :
	;//Remainder = 2
	mov esi, OFFSET String2
	mov ebx, LENGTHOF String2

JMP BOTTOM

lowerUpQuarter :

	cmp edx, 4

JA remainder5

	;//Remainder = 4
	mov esi, OFFSET String4
	mov ebx, LENGTHOF String4

JMP BOTTOM

remainder5 :
	;//Remainder = 5
	mov esi, OFFSET String5
	mov ebx, LENGTHOF String5

JMP BOTTOM

upperHalf :
	cmp edx, 10
JB upperBotQuarter
JA upperTopQuarter

	;//Remainder = 10
	mov esi, OFFSET String10
	mov ebx, LENGTHOF String10

JMP BOTTOM

upperBotQuarter :

	cmp edx, 8

JB remainder7
JA remainder9

	;//Remainder = 8
	mov esi, OFFSET String8
	mov ebx, LENGTHOF String8

JMP BOTTOM

remainder7 :
	;//Remainder = 7
	mov esi, OFFSET String7
	mov ebx, LENGTHOF String7

JMP BOTTOM

remainder9 :
	;//Remainder = 9
	mov esi, OFFSET String9
	mov ebx, LENGTHOF String9

JMP BOTTOM

upperTopQuarter :

	cmp edx, 12

JB remainder11
JA remainder13

	;//Remainder = 12
	mov esi, OFFSET String12
	mov ebx, LENGTHOF String12

JMP BOTTOM

remainder11 :
	;//Remainder = 11
	mov esi, OFFSET String11
	mov ebx, LENGTHOF String11

JMP BOTTOM

remainder13 :
	;//Remainder = 13
	mov esi, OFFSET String13
	mov ebx, LENGTHOF String13

JMP BOTTOM

BOTTOM :

ret; return to main proc
getWord endp; End getWord proc

;// --------------------------------------------------------
;//					userGuess Procedure
;//
;// Receives: N / A
;// Returns: Win / Lose prompt and win / loss count
;// Requires: N / A
;//
;// Description: Asks user to guess word or letter. Calls
;//				letterGuess or wordGuess proc based on choice
;//				
;//
;// ----------------------------------------------------------

userGuess proc
.data

	whichGuess BYTE "Do you wish to guess a letter or the whole word: (1-Letter 2-Word) ", 0h
	winPrompt BYTE "That is correct. You Win.", 0Dh, 0Ah, 0h
	losePrompt BYTE "Out of Guesses. You Lose.", 0Dh, 0Ah, 0h

.code

	mov ecx, 10									;// loop counter set to 10 for number of guesses 

L1:

	cmp winVar, 1								;//If all characters have been matched winVar is set to 1 or true to indicate that the game has been won

JE userWins										;//skip to bottom if user has already won

	mov edi, OFFSET dashArray
	call displayWord							;//display array
	call crlf									;//new line

askAgain :

	mov edx, OFFSET whichGuess
	call writeString							;//Prompt user for letter or word guess
	call readDec								;//get user input of decimal
	call crlf									;//new line

	cmp eax, 1

JNE notLetter									;//user for error checking

	call letterGuess							;//gets users char guess and compares it to the word

JMP bottom

notLetter :
	cmp eax, 2

JNE askAgain									;//loop back to top if input is not 1 or 2

	call wordGuess								;//gets users word guess and compares it to the word

bottom :

loop L1

	sub ebx, 1
	cmp numOfMatches, ebx						;//IF equal the user has won the game

JE userWins

	mov edx, OFFSET losePrompt					;//user is out of guesses and loses. 
	call WriteString							;//Displays losing prompt
	add loseCount, 1							;//Adds 1 to loss count

JMP gameDone

userWins :
	mov edx, OFFSET winPrompt					;//User won
	call WriteString
	add winCount, 1								;//Adds 1 to win count

JMP gameDone


gameDone :

ret
userGuess endp


;// --------------------------------------------------------
;//					letterGuess Procedure
;//
;// Receives: ESI - Random word OFFSET, EDI - dashArray offset
;// Returns: Char letter in dashArray if their is a match
;//			prompt if guess is incorrect with number of guesses left
;// Requires: 
;//
;// Description: User guesses a letter and that letter is compared
;//				to each letter of the randomly generated word. If
;//				it is a match, it is added in the correct position of
;//				the dashArray.
;//				
;// ----------------------------------------------------------

letterGuess proc

.data

	guessLetter BYTE "Guess a letter: ", 0h
	noWordMatch BYTE "That is incorrect. Guesses Left: ", 0h
	letterAlreadyGuessed BYTE "Letter already guessed.", 0Dh, 0Ah, 0h
	guessesLeft BYTE "Guesses Left: ", 0h

.code


	sub ebx, 1									;//Removes the null terminating char for loop counter
	cmp numOfMatches, ebx						;//does the number of matches = the size of the word?, If yes, user wins

JE winner										;// skip code if the user has won

	push ecx									;//push stack
	push esi

	mov edx, OFFSET guessLetter
	call WriteString							;//Display guess letter prompt 
	call readChar								;//User inputs char
	call writeChar								;//Displays users input char
	call crlf									;//new line

	and al, 0DFH								;//convert lowercase input to uppercase. If uppercase, it remains uppercase

	mov ecx, ebx

	call alreadyGuessed							;//Checks if the letter was already guessed
	cmp edx, 1

JE guessed

	mov ecx, ebx
	mov edi, OFFSET dashArray

L2 :

	cmp al, [esi]								;//Determine if user input matches character of random word

JE matches										;//if matches exit loop

	inc esi										;//move to next word in the array
	inc edi										;//used to keep track of char location to input if a match exists

loop L2

JMP notAMatch

guessed :
	pop esi
	pop ecx
	mov edx, OFFSET letterAlreadyGuessed
	call WriteString

	mov edx, OFFSET guessesLeft
	call WriteString							;//Display incorrect guess prompt
	add ecx, 1									;//If user enters already guessed letter, it does not count against total number of guesses
	call numOfGuessesLeft						;//Display number of guesses left

JMP BTM

matches :

	mov[edi], al								;//If a match insert in correct location of dashArray

	pop esi										;//pop stack
	pop ecx

	mov edx, OFFSET guessesLeft
	call WriteString							;//Display incorrect guess prompt
	call numOfGuessesLeft						;//Display number of guesses left

	add numOfMatches, 1							;//Increase number of matches
	cmp numOfMatches, ebx						;//determine if the user is a winner if number of matches = size of random word

JE winner

JMP BTM

notAMatch :
	pop esi										;//pop stack
	pop ecx

	mov edx, OFFSET noWordMatch
	call WriteString							;//Display incorrect guess prompt
	call numOfGuessesLeft						;//Display number of guesses left	

JMP BTM

winner :
	add ebx, 1
	mov edi, OFFSET dashArray
	call displayWord							;//display dashArray
	call crlf									;//new line
	add winVar, 1								;//User has won the game

JMP botWin

BTM :

	add ebx, 1

botWin :

	ret
	letterGuess endp

;// --------------------------------------------------------
;//					numOfGuessesLeft Procedure
;//
;// Receives: ECX - Whats left in loop counter
;// Returns: Number of guesses left display
;// Requires: N/A
;//
;// Description: Dispays number of guesses left
;//				
;// ----------------------------------------------------------

numOfGuessesLeft proc

	mov eax, 0
	mov eax, ecx
	sub eax, 1
	call writeDec								;//display number of guesses left
	call crlf									;//new line

ret
numOfGuessesLeft endp

;// --------------------------------------------------------
;//					alreadyGuessed Procedure
;//
;// Receives: EDI - dashArray OFFSET; EBX - word size; AL - user Guess
;// Returns: 1-true (guessed) 0-false (not guessed) in EDX
;// Requires: N/A
;//
;// Description: Determines if the letter was already guessed
;//				
;// ----------------------------------------------------------

alreadyGuessed proc

	mov edi, OFFSET dashArray

L5 :
	cmp al, [edi]								;//Determine if letter was already guessed

JE wasGuessed

	inc edi

loop L5

	mov edx, 0

JMP bot
wasGuessed :

	mov edx, 1

bot :


	ret
	alreadyGuessed endp

;// --------------------------------------------------------
;//					wordGuess Procedure
;//
;// Receives: ESI - Random word OFFSET
;// Returns: Char letter in dashArray if their is a match
;//			prompt if guess is incorrect with number of guesses left
;// Requires: 
;//
;// Description: User guesses a word and each letter of that word is compared
;//				to each letter of the randomly generated word. If
;//				all match the user wins.
;//				
;// ----------------------------------------------------------

wordGuess proc
.data

	;//prompts
	guessWord BYTE "Guess a word: ", 0h
	noMatch BYTE "That is incorrect. Guesses Left: ", 0h
	userInput BYTE 10 DUP(0)					;//Array for user word input

.code
	push ecx

	mov edx, OFFSET guessWord
	call WriteString
	mov edx, OFFSET userInput					;//user input array offset
	mov ecx, SIZEOF userInput					;//max size of 10
	call ReadString								;//read user input

	call capitalizeLetters						;// function converts lowercase to uppercase, or keeps uppercase

	push esi

	sub ebx, 1
	mov ecx, ebx								;//loop counter = size of random word
	push ebx

L1 :

	mov al, [edx]
	mov bl, [esi]
	cmp bl, al									;//compare each letter of each word

JNE wordNotMatch								;//if not a match exit loop

	inc esi
	inc edx

loop L1

	pop ebx
	pop esi
	pop ecx

JMP matches

wordNotMatch :
	pop ebx
	pop esi
	pop ecx
	mov edx, OFFSET noMatch						;//Not a match prompt
	call WriteString
	mov eax, 0
	mov eax, ecx
	sub eax, 1
	call writeDec								;//number of guesses left
	call crlf									;//new line

JMP BTM

matches :
	push esi
	push edi
	push ecx

	mov edi, OFFSET dashArray
	mov ecx, ebx

L3 :

	mov al, [esi]
	mov[edi], al								;//input user word into dashArray
	inc edi
	inc esi

loop L3

	pop ecx
	pop edi
	pop esi

	mov numOfMatches, ebx						;//IF a match, numOfmatches = size of word
	mov winVar, 1								;//user wins winVar = true or 1

BTM:
	add ebx, 1

ret
wordGuess endp

;// --------------------------------------------------------
;//					capitalizeLetters Procedure
;//
;// Receives: EDX - userInput offset
;// Returns: Uppercase word in userInput with EDX offset
;// Requires: 
;//
;// Description: User guessed word is all capitilized
;//				
;// ----------------------------------------------------------

capitalizeLetters proc

	push edx

	mov ecx, ebx

L4 :

	mov al, [edx]
	and al, 0DFH								;//capitilize lowercase letters
	mov[edx], al								;//move uppercase letters back into userInput array

	inc edx


loop L4


	pop edx
ret
capitalizeLetters endp

;// --------------------------------------------------------
;//					displayWord Procedure
;//
;// Receives: Word OFFSET in ESI and LENGTHOF word in EBX
;//			  dashArray OFFSET in edi
;// Returns: dashArray displayed
;// Requires: N / A
;//
;// Description: Displays dashArray
;//			     
;//
;// ----------------------------------------------------------

displayWord proc

.data

	wordDisplay BYTE "Word: ", 0h

.code

	push ecx									;// preserve loop counter
	mov edx, OFFSET wordDisplay					;//Prompt with Word:
	call WriteString

	sub ebx, 1
	mov ecx, ebx

L1 :

	mov al, [edi]								;//Display word with spaces between each char
	call writeChar

	mov al, ' '
	call writeChar

	INC edi
loop L1

	add ebx, 1
	pop ecx
ret
displayWord endp

end main

