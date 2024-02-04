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

COMBINATION EQU 2_1000  ;the 2_ here means binary, if we dont want our code to be 000,we put 0001, the last 1 is for the load button. 
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
    ORR R0,R0, #0x3         
	STR R0, [R1]   
    
    ;STEP 7
    LDR R1, =GPIO_PORTN_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #0x3                                    
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
    ORR R0,R0, #0x00          
	STR R0, [R1]   
    
	;STEP 7
    LDR R1, =GPIO_PORTM_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #0xF             ;which means the last 4 bit, also can be wtitten in binary 2_001111;     
	                          
    STR R0, [R1]    
	BX  LR                     


State_Init LDR R5,=GPIO_PORTN_DATA_R  ;Locked is the Initial State
	       MOV R4,#2_0000010 ; the initial state is locked, so D1 ON
	       STR R4,[R5]
	       BX LR 

Start                             
	BL  PortN_Init                
	BL  PortM_Init
	BL  State_Init ;call stste init to lock 
	LDR R0, = GPIO_PORTM_DATA_R  ; Inputs set pointer to the input 
	LDR R3, =COMBINATION         ;R3 stores our combination
	
Loop
			LDR R1,[R0]        ;load the cotent of data register into r1     
			AND R2,R1,#2_001111 ; we only care about the 1111 bits . and store into r2. bit masking. 
			CMP R2,R3  ; we compare r2 and r3, r3 store the combination to unlock, 
			BEQ Unlocked_State  ;if R2 = R3, we go to unlock state 
			BNE Locked_State    ; if not, we go to lockd state 
 
	
 
Locked_State                    
	LDR R5,=GPIO_PORTN_DATA_R
	MOV R4,#2_00000010  ; if licked, we light up 01 in prot n  D1 still ON
	STR R4,[R5]
	B Loop ;back to loop 
	
Unlocked_State
	LDR R5, =GPIO_PORTN_DATA_R
	MOV R4,#2_00000001  ; if unlock, we light up 10 in port n D2 ON. 
	STR R4, [R5]
	B Loop
	
	ALIGN   
    END  