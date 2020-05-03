/*
 * gpio_init.c
 *
 *  Created on: 4 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: gpio_init.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 4 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.3.4
 *
 * Description:
 * The XGpio objects used in this project,
 * including push buttons, LEDs, 7-segment displays, VGA region & colour, and slide switches, are initialised here.
 * Push buttons are used as the pedestrian buttons. LEDs can indicate the traffic light sequence and pedestrian buttons
 * being pressed or not. 7-segment displays show the remaining time for each light. VGA region & colour are used to display
 * traffic light on the monitor. Slide switches are used as input to control the modes and change the light period.
 */

/*
 * XGpio objects and corresponding IDs
 *
 * 			Object				ID
 * 			SEG7_HEX_OUT		0
 * 			SEG7_SEL_OUT		1
 * 			LED_OUT				2
 * 			P_BTN_UP			6
 * 			P_BTN_DOWN			3
 * 			P_BTN_LEFT			4
 * 			TR1_RED				7
 * 			TR1_YELLOW			10
 * 			TR1_STRAIGHT		11
 * 			PD_LIGHT			13
 * 			PD_GO				18
 * 			TR2_RED				15
 * 			TR2_YELLOW			16
 * 			TR2_STRAIGHT		17
 * 			TR1_RIGHT_TURN		12
 * 			TR2_RIGHT_TURN		14
 * 			SlideSwtiches		19
 */

#include "xgpio.h"		/* Added for used types */
#include "gpio_init.h"	/* Added for XGpio objects */

XStatus initGpio (void)
{
	XStatus status;

	status = XGpio_Initialize(&SEG7_HEX_OUT, 0);	/* Initialise the SEG7_HEX_OUT */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&SEG7_SEL_OUT, 1);	/* Initialise the SEG7_SEL_OUT */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&LED_OUT, 2);			/* Initialise LEDs */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_UP, 6);		/* Initialise the up button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_DOWN, 3);		/* Initialise the down button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_LEFT, 4);		/* Initialise the left button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_RED, 7);			/* Initialise red light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_YELLOW, 10);		/* Initialise yellow light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_STRAIGHT, 11);	/* Initialise straight light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&PD_STOP, 13);		/* Initialise pedestrian stop */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_RED, 15);		/* Initialise red light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_YELLOW, 16);		/* Initialise yellow light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_STRAIGHT, 17);	/* Initialise straight light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&SlideSwitches, 19);	/* Initialise slide switches */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_RIGHT_TURN, 12);	/* Initialise right-turn light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_RIGHT_TURN, 14);	/* Initialise right-turn light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&PD_GO, 18);			/* Initialise pedestrians go */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
