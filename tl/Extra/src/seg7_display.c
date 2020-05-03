/*
 * This file is from the support materials of Engineering Software 3 Laboratory 4.
 * Amended by: Yunfan Jiang (s1886282)
 * Used on: 7 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.2.3
 *
 * Description:
 * Driving file for 7-segment displays.
 *
 * Modified content:
 * Macros for 7-segment codes of letters are defined in corresponding header file firstly.
 * Then function "calculateDigits ()" is modified. The interface variables "All_Off_Flag" and "Warning_Flag" from master control module
 * are used to decide the digits to be displayed.
 * When in "all-off" mode, the flag is active, then the three digits will be assigned to word pattern "oFF".
 * When in "emergency/warning" mode, the flag is active, then the four digits to be displayed will be assigned to word pattern "dAnG".
 * When in normal operation, namely both flags are inactive, the digits to be displayed will be assigned normally.
 *
 */

#include <stdio.h>
#include "xil_types.h"		// Added for integer type definitions
#include "seg7_display.h"	// Added for 7-segment definitions
#include "gpio_init.h"
#include "master_control_module.h"	/* Added for interface variable "All_Off_Flag" and "Warning_Flag" */

u8 digitDisplayed = FALSE;
u8 digits[4];
u8 numOfDigits;
u8 digitToDisplay;
u8 digitNumber;

void displayNumber(u16 number)
{
	u8 count;
	/* Note that 9999 is the maximum number that can be displayed
	 * Therefore, check if the number is less than or equal to 9999
	 * and display the number otherwise, display dashes in all the four segments
	 */
	if (number <= 9999)
	{
		// Call the calculateDigits method to determine the digits of the number
		calculateDigits(number);
		/* Do not display leading zeros in a number,
		 * but if the entire number is a zero, it should be displayed.
		 * By displaying the number from the last digit, it is easier
		 * to avoid displaying leading zeros by using the numOfDigits variable
		 */
		count = 4;
		while (count > 4 - numOfDigits)
		{
			digitToDisplay = digits[count-1];
			digitNumber = count;
			count--;
			/* Wait for timer interrupt to occur and ISR to finish
			 * executing digit display instructions
			 */
			while (digitDisplayed == FALSE);
			digitDisplayed = FALSE;
		}
	}
	else
	{
		// Display "----" to indicate that the number is out of range
		count = 1;
		while (count < 5)
		{
			digitToDisplay = NUMBER_DASH;
			digitNumber = count;
			count++;
			/* Wait for timer interrupt to occur and ISR to finish
			 * executing digit display instructions
			 */
			while (digitDisplayed == FALSE);
			digitDisplayed = FALSE;
		}
	}
}

void calculateDigits(u16 number)
{
	u8 fourthDigit;
	u8 thirdDigit;
	u8 secondDigit;
	u8 firstDigit;

	// Check if number is up to four digits
	if (number > 999)
	{
		numOfDigits = 4;

		fourthDigit  = number % 10;
		thirdDigit = (number / 10) % 10;
		secondDigit  = (number / 100) % 10;
		firstDigit = number / 1000;
	}
	// Check if number is three-digits long
	else if (number > 99 && number < 1000)
	{
		numOfDigits = 3;

		fourthDigit  = number % 10;
		thirdDigit = (number / 10) % 10;
		secondDigit  = (number / 100) % 10;
		firstDigit = 0;
	}
	// Check if number is two-digits long
	else if (number > 9 && number < 100)
	{
		numOfDigits = 2;

		fourthDigit  = number % 10;
		thirdDigit = (number / 10) % 10;
		secondDigit  = 0;
		firstDigit = 0;
	}
	// Check if number is one-digit long
	else if (number >= 0 && number < 10)
	{
		numOfDigits = 1;

		fourthDigit  = number % 10;
		thirdDigit = 0;
		secondDigit  = 0;
		firstDigit = 0;
	}

	if ((All_Off_Flag == 1) & (Warning_Flag == 0))	/* Display word "oFF" when in "all-off" mode*/
	{
		digits[0] = firstDigit;
		digits[1] = LETTER_O;
		digits[2] = LETTER_F;
		digits[3] = LETTER_F;
	}
	else if ((All_Off_Flag == 0) & (Warning_Flag == 1))	/* Display word "dAnG", which means "Dangerous", when in "emergency/warning" mode */
	{
		digits[0] = LETTER_D;
		digits[1] = LETTER_A;
		digits[2] = LETTER_N;
		digits[3] = LETTER_G;
	}
	else
	{
		digits[0] = firstDigit;
		digits[1] = secondDigit;
		digits[2] = thirdDigit;
		digits[3] = fourthDigit;
	}

	return;
}

void displayDigit()
{
	/*
	 * This timer ISR is used to display the digits
	 */
	switch (digitToDisplay)
	{
		case NUMBER_BLANK :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_BLANK);
			break;
		case 0 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_ZERO);
			break;
		case 1 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_ONE);
			break;
		case 2 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_TWO);
			break;
		case 3 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_THREE);
			break;
		case 4 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_FOUR);
			break;
		case 5 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_FIVE);
			break;
		case 6 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_SIX);
			break;
		case 7 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_SEVEN);
			break;
		case 8 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_EIGHT);
			break;
		case 9 :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_NINE);
			break;
		case NUMBER_DASH :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_DASH);
			break;
		case LETTER_O :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_O);
			break;
		case LETTER_F :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_F);
			break;
		case LETTER_D :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_D);
			break;
		case LETTER_A :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_A);
			break;
		case LETTER_N :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_N);
			break;
		case LETTER_G :
			XGpio_DiscreteWrite(&SEG7_HEX_OUT, 1, DIGIT_G);
			break;
		default:
			break;
	}

	// Select the appropriate digit
	if (digitNumber == 1) {
		XGpio_DiscreteWrite(&SEG7_SEL_OUT, 1, EN_FIRST_SEG);
	}
	else if (digitNumber == 2) {
		XGpio_DiscreteWrite(&SEG7_SEL_OUT, 1, EN_SECOND_SEG);
	}
	else if (digitNumber == 3) {
		XGpio_DiscreteWrite(&SEG7_SEL_OUT, 1, EN_THIRD_SEG);
	}
	else if (digitNumber == 4) {
		XGpio_DiscreteWrite(&SEG7_SEL_OUT, 1, EN_FOURTH_SEG);
	}

	digitDisplayed = TRUE;
	return;
}
