/*
 * led_shift.c
 *
 *  Created on: 9 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: led_shift.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 9 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.2.3
 *
 * Description:
 * This function is from previous work in Engineering Software 3 Laboratory 3.
 * The LEDs will shift from one side to the other side and repeat continuously.
 * A flag called "DIRECTION" is used to decide the shifting direction.
 * After LED shifting, it will check whether the light gets end or not and change the direction flag.
 */

#include "xil_types.h"	/* Added for type definition */
#include "rotate.h"		/* Added for rotate functions */

/* Definition for interface variable */
/* This interface variable will be accessed by Display_Module */
u16 ledValue = 0x0001;

/* Definition for within-module variable */
static int DIRECTION = 0;	/* Direction flag. 0 for left shifting, 1 for right shifting */

/* Definition for interface function */
/* This function will be called in ISR function.
 * This function can shift the LED from one side to the other side, and repeat continuously.
 */
void LED_Shift ()
{
	if (DIRECTION == 0)	/* Left shifting */
	{
		ledValue = rotateLeft(ledValue);
	}
	if (DIRECTION == 1)	/* Right shifting */
	{
		ledValue = rotateRight(ledValue);
	}
	/* When light gets the end, change its direction */
	if ((DIRECTION == 0) & (ledValue == 0x8000))	/* Check if the LED gets the leftmost */
		DIRECTION = 1;
	if ((DIRECTION == 1) & (ledValue == 0x0001))	/* CHect if the LED gets the rightmost */
		DIRECTION = 0;
}
