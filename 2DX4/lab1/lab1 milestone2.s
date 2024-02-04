;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Name: tianze zhang; Put your name here for labs
; Student Number: 400208135 
; Lab Section: l01
; Description of Code: This code allows User LED D3 To Turn On (Put a brief description of your code) 
; Last Modified: January 22nd 2021
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ADDRESS DEFINTIONS

;The EQU directive gives a symbolic name to a numeric constant, a register-relative value or a program-relative value


SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register (RCGCGPIO Register)
GPIO_PORTN_DIR_R             EQU 0x40064400  ;GPIO Port N Direction Register address  p1202 of the reference manual 
GPIO_PORTN_DEN_R             EQU 0x4006451C  ;GPIO Port N Digital Enable Register address
GPIO_PORTN_DATA_R            EQU 0x400643FC  ;GPIO Port N Data Register address WE ARE ACESS ALL 8 BITS, IN STUDIO 0 P21
GPIO_PORTM_DIR_R             EQU 0x40063400  ;GPIO Port M Direction Register address  p1202 of the reference manual 
GPIO_PORTM_DEN_R             EQU 0x4006351C  ;GPIO Port M Digital Enable Register address
GPIO_PORTM_DATA_R            EQU 0x400633FC  ;GPIO Port M Data Register address WE ARE A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Do not alter this section

        AREA    |.text|, CODE, READONLY, ALIGN=2 ;code in flash ROM
        THUMB                                    ;specifies using Thumb instructions
        EXPORT Start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Define Functions in your code here 
;The function Port F_Init to configures the GPIO Port F Pin 4 for Digital Output 

Ports_Init
    ; STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R          ;Loads the memory address of RCGCGPIO into register 1(R1); R1 = 0x400FE608
    LDR R0, [R1]                        ;Put the contents of the memory address of RCGCGPIO into register 0 (R0), R0 = 0x00000000
    ORR R0,R0, #0x1000                    ;Performs a bitwise OR operation with the contents of R0 and 0x20 and stores it back into R0, R0 = 0x20 
	                                     ;the bit of N is R12, which is 10^12, covert to hex, it is 0x1000. p326 in the TRM
    STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1,RCGCGPIO now has Ox20 stored in it 
    NOP                                 ;Waiting for GPIO Port F to be enabled
	NOP
	NOP		                        ;Waiting for GPIO Port F to be enabled
	NOP
   
   ; STEP 5
    LDR R1, =GPIO_PORTN_DIR_R           ;Load the memory address of the GPIO Port F DIR Register into register 1 (R1), R1 = 0x4005D400
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DIR Register in R0, R0 = 0x00000000
    ORR R0,R0, #0x1                 	;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x10
    STR R0, [R1]
													;Stores R0 contents into contents of the address located in R1; GPIO Port F Direction Register now has 0x10 stored in it 
    LDR R1, =GPIO_PORTM_DIR_R
	LDR R0, [R1]
	BIC R0, #0x1
	STR R0, [R1]
	
	; STEP 7
    LDR R1, =GPIO_PORTN_DEN_R           ;Load the memory addess of the GPIO Port F DEN Register into register 1 (R1), R1 = 0x4005D51C
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DEN Register in register 0 (R0,), R0 = 0x00000000
    ORR R0, R0, #0x1                  ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x10 
    STR R0, [R1]	                    ;Stores R0 contents into contents of the address located in R1; GPIO Port F DEN Register now has 0x10 stored in it 
										;return
	LDR R1, =GPIO_PORTM_DIR_R
	LDR R0, [R1]
	ORR R0, R0,#0x1
	STR R0, [R1]
	BX  LR

Read_M
	LDR R1, =GPIO_PORTM_DATA_R
	LDR R0, [R1]
	CBZ R0, down
	LDR R1, =GPIO_PORTN_DATA_R
	LDR R0, =0x10
	STR R0, [R1]
	BX LR
down LDR R1, =GPIO_PORTN_DATA_R
	LDR R0, =0x0
	STR R0, [R1]
	BX LR
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Start
	BL Ports_Init
Loop BL Read_M
	B loop
	ALIGN
	END