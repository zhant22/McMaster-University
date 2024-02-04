/* Studio W7-0 Project Code
		Sample code provided for studio to demonstrate periodic interrupt 
		Based upon interrupt texxtbook code by Valvano.

		This code will use an onboard 16-bit timer to trigger an inteerupt.  The trigger
		will cause the timer ISR to execute.  The timer ISR will
		flash the onboard LED on/off.  However, you can adapt this code
		to perform any operations simply by changing the code in the ISR
		
		The program is written to flash the onboard LED at a frequency of 10Hz

		Written by Tom Doyle
		Last Updated: March 1, 2020
*/

// // 2DX4StudioW30E1_Decoding a Button Press
// This program illustrates detecting a single button press.
// This program uses code directly from your course textbook.
//
// This example will be extended for in W21E0 and W21E1.
//
//  Written by Ama Simons
//  January 30, 2020
//  Last Update: January 21, 2020

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "tm4c1294ncpdt.h"
#include "Systick.h"
#include "PLL.h"

void PortL_Init(void){	
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R10;		              // activate the clock for Port E
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R10) == 0){};	        // allow time for clock to stabilize
  GPIO_PORTL_DEN_R = 0b00001111;                         		// Enabled as digital outputs
	GPIO_PORTL_DIR_R = 0b00001111;
	return;
}

void PortM_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R11;                 //activate the clock for Port M
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R11) == 0){};        //allow time for clock to stabilize 
	GPIO_PORTM_DIR_R = 0b00000000;       								    // make PM0 an input, PM0 is reading if the button is pressed or not 
  GPIO_PORTM_DEN_R = 0b00001111;
	return;
}

void PortN0N1_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R12;                 //activate the clock for Port N
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R12) == 0){};
	GPIO_PORTN_DIR_R=0b00000011;
	GPIO_PORTN_DEN_R=0b00000011;
	return;
}

void PortH_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R7;
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R7) == 0){};	
	GPIO_PORTH_DIR_R |= 0xF;												
	GPIO_PORTH_AFSEL_R &= ~0xF;		 								
	GPIO_PORTH_DEN_R |= 0xF;																																			
	GPIO_PORTH_AMSEL_R &= ~0xF;		 									
	return;
}

char result;
char keyPad[4][4] = {{'1', '2', '3', 'A'},{'4', '5', '6', 'B'},{'7', '8', '9', 'C'},{'*', '0', '#', 'D'}};
	
void getChar(uint32_t row, uint32_t col) {
	int rowIndex, colIndex;
	if ((col & 0b00000001) == 0) {
		colIndex = 0;
	} else if ((col & 0b00000010) == 0) {
		colIndex = 1;
	} else if ((col & 0b00000100) == 0) {
		colIndex = 2;
	} else if ((col & 0b00001000) == 0) {
		colIndex = 3;
	}
	
	if ((row & 0b00000001) == 0) {
		rowIndex = 0;
	} else if ((row & 0b00000010) == 0) {
		rowIndex = 1;
	} else if ((row & 0b00000100) == 0) {
		rowIndex = 2;
	} else if ((row & 0b00001000) == 0) {
		rowIndex = 3;
	}
	
	result = keyPad[rowIndex][colIndex];
}

void setLED(bool state) {	
	if (state) {
		GPIO_PORTN_DATA_R = 0b00000001;
	} else {
		GPIO_PORTN_DATA_R = 0b00000000;
	}
}

void DutyCycleForward(int delay) {
	GPIO_PORTH_DATA_R = 0b00001100;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00000110;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00000011;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00001001;
	SysTick_Wait10ms(delay);
}

void DutyCycleReverse(int delay) {
	GPIO_PORTH_DATA_R = 0b00001001;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00000011;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00000110;
	SysTick_Wait10ms(delay);
	GPIO_PORTH_DATA_R = 0b00001100;
	SysTick_Wait10ms(delay);
}

// @param number of rotations, 1 = CW, -1 = CCW
void rotate(int delay, int dir) {
	if(dir == 1) {
			DutyCycleForward(delay);
	} else if(dir == -1) {
			DutyCycleReverse(delay);
	}
}

int angleInSteps = 0;
int direction = 0;
int delay = 0;

bool setAngle = false;
bool setDir = false;
bool setDelay = false;

double stepsPerRot = 512.0;

int main(void){
	PortL_Init();
	PortM_Init();
	PortN0N1_Init();
	PortH_Init();
	PLL_Init();																			// Default Set System Clock to 120MHz
	SysTick_Init();																	// Initialize SysTick configuration
	
	
	
	int i = 0, tickCounter = 0;
	GPIO_PORTL_DATA_R = 0b00000000;
	
	while(1){
		result = '\0';
		// 0001 0010 0100 1000
		
		for(i = 0; i < 4; i++) {		
			if (i == 0) {
				GPIO_PORTL_DATA_R = 0b00001110;
			} else if (i == 1) {
				GPIO_PORTL_DATA_R = 0b00001101;
			} else if (i == 2) {
				GPIO_PORTL_DATA_R = 0b00001011;
			} else {
				GPIO_PORTL_DATA_R = 0b00000111;
			}
			
			while((GPIO_PORTM_DATA_R & 0b00000001)==0){
					getChar(GPIO_PORTL_DATA_R, GPIO_PORTM_DATA_R);
			}
			
			while((GPIO_PORTM_DATA_R & 0b00000010)==0){
					getChar(GPIO_PORTL_DATA_R, GPIO_PORTM_DATA_R);
			}
			
			while((GPIO_PORTM_DATA_R & 0b00000100)==0){
					getChar(GPIO_PORTL_DATA_R, GPIO_PORTM_DATA_R);
			}
			
			while((GPIO_PORTM_DATA_R & 0b00001000)==0){
					getChar(GPIO_PORTL_DATA_R, GPIO_PORTM_DATA_R);
			}
		}
		
		if (!setAngle) {
			if (result == 'A') {
				setAngle = true;
				angleInSteps = (11.25 / 360.0) * stepsPerRot;
			} else if (result == 'B') {
				setAngle = true;
				angleInSteps = (45.0 / 360.0) * stepsPerRot;
			} else if (result == 'C') {
				setAngle = true;
				angleInSteps = (90.0 / 360.0) * stepsPerRot;
			} else if (result == 'D') {
				setAngle = true;
				angleInSteps = stepsPerRot;
			}
		}
		
		if (!setDir && setAngle) {
			if (result == '*') {
				setDir = true;
				direction = 1;
			} else if (result == '#') {
				setDir = true;
				direction = -1;
			}
		}
		
		if (!setDelay && setAngle && setDir) {
			if (result >= '1' && result <= '9') {
				setDelay = true;
				delay = result - '0';
			}
		}
		
		if (setAngle && setDir && setDelay) {
			rotate(delay, direction);
			tickCounter++;
			if (tickCounter % angleInSteps == 0) {
				setLED(true);
			} else {
				setLED(false);
			}
			
			
		}
		
		if (result == '0') {
			setAngle = false;
			setDir = false;
			setDelay = false;
			angleInSteps = 0;
			direction = 0;
			delay = 0;
			tickCounter = 0;
		}
	}
}