;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Name: tianze zhang(Dylan zhang)
; Student Number: 400208135
; Lab Section: L01
; Description of Code: using 1000 as combination code to turn on D2 as successful unlock. 

 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ADDRESS DEFINTIONS

;The EQU directive gives a symbolic name to a numeric constant, a register-relative value or a program-relative value


SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register (RCGCGPIO Register)

GPIO_PORTN_DIR_R             EQU 0x40064400  ;GPIO Port N Direction Register address 
GPIO_PORTN_DEN_R             EQU 0x4006451C  ;GPIO Port N Digital Enable Register address
GPIO_PORTN_DATA_R            EQU 0x400643FC  ;GPIO Port N Data Register address
	
GPIO_PORTM_DIR_R             EQU 0x40063400  ;GPIO Port M Direction Register Address (Fill in these addresses)
GPIO_PORTM_DEN_R             EQU 0x4006351C  ;GPIO Port M Direction Register Address (Fill in these addresses)
GPIO_PORTM_DATA_R            EQU 0x400633FC  ;GPIO Port M Data Register Address      (Fill in these addresses) 
	
GPIO_PORTF_DIR_R             EQU 0x4005D400  ;GPIO Port F Direction Register address 
GPIO_PORTF_DEN_R             EQU 0x4005D51C  ;GPIO Port F Digital Enable Register address
GPIO_PORTF_DATA_R            EQU 0x4005D3FC  ;GPIO Port F Data Register address 	
	
counter 					 EQU 0x8888	

COMBINATION EQU 2_1001  ;the 2_ here means binary, if we dont want our code to be 1000,we put0001 

digit1 	EQU 2_1001
digit2 	EQU 2_1010
digit3 	EQU 2_1100
digit4 	EQU 2_1000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Do not alter this section

        AREA    |.text|, CODE, READONLY, ALIGN=2 ;code in flash ROM
        THUMB                                    ;specifies using Thumb instructions
        EXPORT Start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Function PortN_Init 
PortN_Init 
    ;STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R 
    LDR R0, [R1]   
    ORR R0,R0, #0x1000           				          
    STR R0, [R1]               
    NOP 
    NOP   
   
    ;STEP 5
    LDR R1, =GPIO_PORTN_DIR_R   
    LDR R0, [R1] 
    ORR R0,R0, #2_011111        
	STR R0, [R1]   
    
    ;STEP 7
    LDR R1, =GPIO_PORTN_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #2_011111                                     
    STR R0, [R1]  
    BX  LR                            
 
PortM_Init 
    ;STEP 1 
	LDR R1, =SYSCTL_RCGCGPIO_R       
	LDR R0, [R1]   
    ORR R0,R0, #0x800      ;port M is R11
	STR R0, [R1]   
    NOP 
    NOP   
 
    ;STEP 5
    LDR R1, =GPIO_PORTM_DIR_R   
    LDR R0, [R1] 
    ORR R0,R0, #0xC0          
	STR R0, [R1]   
    
	;STEP 7
    LDR R1, =GPIO_PORTM_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #2_011111           
	                          
    STR R0, [R1]    
	BX  LR    

PortF_Init
    ; STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R          ;Loads the memory address of RCGCGPIO into register 1(R1); R1 = 0x400FE608
    LDR R0, [R1]                        ;Put the contents of the memory address of RCGCGPIO into register 0 (R0), R0 = 0x00000000
    ORR R0,R0, #0x20                    ;Performs a bitwise OR operation with the contents of R0 and 0x20 and stores it back into R0, R0 = 0x20 
    STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1,RCGCGPIO now has Ox20 stored in it 
    NOP                                 ;Waiting for GPIO Port F to be enabled
	NOP                                 ;Waiting for GPIO Port F to be enabled
  
   ; STEP 5
    LDR R1, =GPIO_PORTF_DIR_R           ;Load the memory address of the GPIO Port F DIR Register into register 1 (R1), R1 = 0x4005D400
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DIR Register in R0, R0 = 0x00000000
    ORR R0,R0, #2_011111                  	;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x10
    STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1; GPIO Port F Direction Register now has 0x10 stored in it 
    
	; STEP 7
    LDR R1, =GPIO_PORTF_DEN_R           ;Load the memory addess of the GPIO Port F DEN Register into register 1 (R1), R1 = 0x4005D51C
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DEN Register in register 0 (R0,), R0 = 0x00000000
    ORR R0, R0, #2_011111                 ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x10 
    STR R0, [R1]	                    ;Stores R0 contents into contents of the address located in R1; GPIO Port F DEN Register now has 0x10 stored in it 
    BX  LR        


State_Init 
	LDR R5,=GPIO_PORTN_DATA_R  ;Locked is the Initial State
	MOV R4,#2_0000010 ; the initial state is locked, so D1 ON
	STR R4,[R5]
	BX LR 
	
	
IsZero
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1, [R0]
	AND R2, R1, #2_00010000
	CMP R2, #2_00000000
	BNE IsZero
	BX LR
	
IsOne
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1, [R0]
	AND R2, R1, #2_00010000
	CMP R2, #2_00010000
	BNE IsOne
	BX LR

Start                             
	BL  PortN_Init              ;The BL instruction is like a function call 
	BL  PortM_Init				;The BL instruction is like a function call
	BL  State_Init 				;The BL instruction is like a function call
	
State_0	
	BL IsZero
	BL IsOne
	MOV R3, #2_00010001      	;Load the COMBINATION code into register 3 (R1), R3 = 0x400643FC 
	AND R2,R1,#2_00010001 		;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x3
	CMP R2,R3  					;Perform the comparesion between the input code and combination code. 
	BEQ State_1  				;If R2 = R3, begin function Unlocked_State
	BNE State_0  			;If R2 != R3, begin function Locked_State
	
State_1	

	LDR R5, =GPIO_PORTN_DATA_R	
	MOV R4,#0x3					
	STR R4, [R5]
	
	BL IsZero
	BL IsOne
	
	
	MOV R3, #2_00010000         ;LDR R3, = Digit_11       	;Load the COMBINATION code into register 3 (R1), R3 = 0x400643FC
	AND R2,R1,#2_00010000 		;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x3
	CMP R2,R3  		;Perform the comparesion between the input code and combination code. 
	
	BEQ State_2 				;If R2 = R3, begin function Unlocked_State
	BNE State_0	  			;If R2 != R3, begin function Locked_State
	
	
State_2
	
	LDR R5, =GPIO_PORTN_DATA_R	
	MOV R4,#0x1				
	STR R4, [R5]
	
	BL IsZero
	BL IsOne
	MOV R3, #2_00010000                ;LDR R3, = Digit_11       	;Load the COMBINATION code into register 3 (R1), R3 = 0x400643F
	AND R2,R1,#2_00010000 				;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x3
	CMP R2,R3  					;Perform the comparesion between the input code and combination code. 
	BEQ State_3 	;If R2 = R3, begin function Unlocked_State
	;BEQ state_3_LightOn
	BNE State_0	  			;If R2 != R3, begin function Locked_State
	
State_3
	
	;LDR R5, =GPIO_PORTF_DATA_R          ;Load the memory addess of the GPIO Port F DATA Register into register 1 (R1), R1 = 0x4005D3FC
										;Put the contents of the memory address of GPIO Port F DATA Register 0 (R0), R0 = 0x00000000
    ;MOV R4, #0x1                    ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x10
    ;STR R4, [R5]
	
	LDR R5, =GPIO_PORTN_DATA_R	
	MOV R4,#0x3					
	STR R4, [R5]
	
	BL IsZero
	BL IsOne
	MOV R3, #2_00010000         ;LDR R3, = Digit_11       	;Load the COMBINATION code into register 3 (R1), R3 = 0x400643F
	AND R2,R1,#2_00010000 				;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x3
	CMP R2,R3  					;Perform the comparesion between the input code and combination code. 
	BEQ Unlocked_State		;If R2 = R3, begin function Unlocked_State
	BNE State_0				;If R2 != R3, begin function Locked_State



Unlocked_State
	LDR R5, =GPIO_PORTN_DATA_R	;Load the memory addess of the GPIO Port N DATA Register into register 5 (R5), R5 = 0x400643FC
	MOV R4,#0x1					;Move 0x1 to R4.
	STR R4, [R5]				;Stores R4 contents into contents of the address located in R5; GPIO Port N DATA Register now has 0x2 stored in it 	
	

state_2_LightOn
	BL  PortF_Init                      ;The BL instruction is like a function call 
    ;STEP 8                              		
    LDR R1, =GPIO_PORTF_DATA_R          ;Load the memory addess of the GPIO Port F DATA Register into register 1 (R1), R1 = 0x4005D3FC
	LDR R0,[R1]                         ;Put the contents of the memory address of GPIO Port F DATA Register 0 (R0), R0 = 0x00000000
    ORR R0,R0, #0x1                    ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x10
    STR R0, [R1]  

state_3_LightOn	
	BL  PortF_Init                      ;The BL instruction is like a function call 
    ;STEP 8                              		
    LDR R1, =GPIO_PORTF_DATA_R          ;Load the memory addess of the GPIO Port F DATA Register into register 1 (R1), R1 = 0x4005D3FC
	LDR R0,[R1]                         ;Put the contents of the memory address of GPIO Port F DATA Register 0 (R0), R0 = 0x00000000
    ORR R0,R0, #0x10                    ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x10
    STR R0, [R1] 
	
	ALIGN   
    END   