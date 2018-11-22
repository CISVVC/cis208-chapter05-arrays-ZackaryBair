;Assignment: Chapter 5 Arrays
;Zackary Bair
;file: asm_main.asm
;
;Write an assembly language function that will do the following: 
	;1. provide a function that will take 3 parameters:
		;The base address of a word (16 bit) array -> array
		;The length of the array
		;An integer -- a scalar

	;The function will iterate over the array and will multiply the scalar by each element in the array. 
	; Each element of the array will then be changed to the scalar multiple.  This is an example
		;a1:  dw  1,2,3,4,5
		;This looks like:
			;a1[0]   a1[1]   a1[2]   a1[3]   a1[4]
			;  1       2       3       4       5
 
	;if the function is called with the above array and a scalar of 5 then the result would be:
		;a1[0]   a1[1]   a1[2]     a1[3]     a1[4]
		;  5      10      15        20        25
;
;Loop through the array and multiply by the scalar

;PLANS
;~~~~~~~~~~~~~~~~~~~
;create array
	;loop for each in arrayLength
	;start at one, fill next index with incremented value
;print array before multiply
;multiply array
;print array


%include "asm_io.inc"
;%define SPACE " ", 0

; initialized data is put in the .data segment
segment .data
        syswrite: equ 4 
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h

	;PARAMETERS (can change)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	arrayLength dd 8 ;the length of an array
		;is dd to stop the 1800 value error I was getting with db
	scalar db 7 ;the integer scalar
	array times 8 dd 0 ;array size arrayLength(8)

	;FORMATTING
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	space db " ", 0
	preMultiplyOutput db "Before scalar multiply: ", 0
	postMultiplyOutput db "After scalar multiply: ", 0
	arrayLengthOutput db "Array length: ", 0
	scalarOutput db "Scalar: ", 0


; uninitialized data is put in the .bss segment
segment .bss


; code is put in the .text segment
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha


; *********** Start  Assignment Code *******************


;CLEAR REGISTERS
;~~~~~~~~~~~~~~~~~
mov eax, 0
mov ebx, 0
mov ecx, 0
mov edx, 0

;FILLS ARRAY
;~~~~~~~~~~~~~~~~
mov eax, array ;put array in ebx to modify
mov ebx, 0 ;value to put in array
mov ecx, [arrayLength] ;counter for loop
mov edx, 0 ;index

fillArray:
	mov [eax + 4 * edx], dword ebx ;puts a value into a spot in the array

	inc edx ;increments the value to put in
	inc ebx ;increments the index
	loop fillArray

mov eax, arrayLengthOutput ;prints out the array length
call print_string
mov eax, [arrayLength]
call print_int
call print_nl
mov eax, scalarOutput ;prints out the scalar
call print_string
mov eax, [scalar]
call print_int
call print_nl

mov eax, preMultiplyOutput
call print_string
call printArray
call multiplyScalar
mov eax, postMultiplyOutput
call print_string
call printArray

; *********** End Assignment Code **********************


        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret


;SUBPROGRAMS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
printArray:
	;Will print out any array contained within EAX
	;Overwrites what is in registers
	enter 0,0 ;setup

b3:
	mov ebx, array ;put array in EBX
	mov ecx, [arrayLength] ;counter for loop
	mov edx, 0 ;index

	printArrayLoop:
		mov eax, [ebx + 4 * edx]
		call print_int
		mov eax, space ;to print spaces in between the indexs in array
		call print_string

		inc edx ;increments the index
		loop printArrayLoop

	call print_nl
	leave
	ret

multiplyScalar:
	;Takes in a scalar
	;Takes in an array from EAX
	;Multiples every index in array by scalar

	enter 0,0 ;setup

	mov ebx, array ;array to multiply
	mov ecx, [arrayLength] ;counter for loop
	mov edx, 0 ;index

b4:
	multiplyLoop:
		mov eax, [ebx + 4 * edx]
		imul eax, [scalar]
		mov [ebx + 4 * edx], eax

		inc edx ;increments the index
		loop multiplyLoop

	leave
	ret

