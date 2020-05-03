/*
 * This file is from the support materials of Engineering Software 3 Laboratory 4, but amended for this design.
 * Amended by: Yunfan Jiang (s1886282)
 * Used on: 7 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.2.1
 *
 * Description:
 * Driving file for 7-segment displays.
 * Modified content:
 * Definition for macros for display "oFF" and 7-segment codes of "oFF".
 * Definition for macros for display "dAnG" and 7-segment codes of "dAnG".
 */

#ifndef __SEG7_DISPLAY_H_
#define __SEG7_DISPLAY_H_

#include "xgpio.h"		// Added for xgpio object definitions

// Definitions for 7-segment BCD codes
#define DIGIT_BLANK		0xFF
#define DIGIT_ZERO 		0xC0
#define DIGIT_ONE  		0xF9
#define DIGIT_TWO  		0xA4
#define DIGIT_THREE  	0xB0
#define DIGIT_FOUR  	0x99
#define DIGIT_FIVE  	0x92
#define DIGIT_SIX  		0x82
#define DIGIT_SEVEN  	0xF8
#define DIGIT_EIGHT  	0x80
#define DIGIT_NINE  	0x90
#define DIGIT_DASH  	0xBF

#define NUMBER_BLANK  	10 	// Note: since 10 cannot be a digit,
 						   	//       it is used to represent a blank digit
#define NUMBER_DASH  	11 	// Note: since 11 cannot be a digit,
 						   	//       it is used to represent "dash"

/* Definition for display "oFF" */
#define LETTER_O		12
#define LETTER_F		13

/* Definition for display "dAnG" */
#define LETTER_D		14
#define LETTER_A		15
#define LETTER_N		16
#define LETTER_G		17


/* Definition for 7-segment codes of "oFF" */
#define DIGIT_O			0xA3
#define DIGIT_F			0x8E

/* Definition for 7-segment codes of "dAnG" */
#define DIGIT_D			0xA1
#define DIGIT_A			0x88
#define DIGIT_N			0xAB
#define DIGIT_G			0xC2

// Definitions for digit selection codes
#define EN_FIRST_SEG	0b0111
#define EN_SECOND_SEG	0b1011
#define EN_THIRD_SEG	0b1101
#define EN_FOURTH_SEG	0b1110

void print(char *str);

int setUpInterruptSystem();
void hwTimerISR(void *CallbackRef);
void displayNumber(u16 number);
void calculateDigits(u16 number);
void displayDigit();

#endif
