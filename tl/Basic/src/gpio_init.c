/*
 * gpio_init.c
 *
 *  Created on: 4 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: gpio_init.c
 * Project Name: Basic Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 4 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.2.3
 *
 * Description:
 * The XGpio objects used in this project,
 * including push buttons, LEDs, 7-segment displays, VGA region & colour, are initialised here.
 * Push buttons are used as the pedestrian buttons. LEDs can indicate the traffic light sequence and pedestrian buttons
 * being pressed or not. 7-segment displays show the remaining time for each light. VGA region & colour are used to display
 * traffic light on the monitor.
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
 * 			TR1_GREEN			11
 * 			PD_LIGHT			13
 * 			TR2_RED				15
 * 			TR2_YELLOW			16
 * 			TR2_GREEN			17
 */

#include "xgpio.h"		/* Added for used types */
#include "gpio_init.h"	/* Added for XGpio objects */

XStatus initGpio (void)
{
	XStatus status;

	status = XGpio_Initialize(&SEG7_HEX_OUT, 0);			/* Initialise the SEG7_HEX_OUT */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&SEG7_SEL_OUT, 1);			/* Initialise the SEG7_SEL_OUT */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&LED_OUT, 2);					/* Initialise LEDs */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_UP, 6);				/* Initialise up button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_DOWN, 3);				/* Initialise down button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&P_BTN_LEFT, 4);				/* Initialise left button */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_RED, 7);					/* Initialise red light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_YELLOW, 10);				/* Initialise yellow light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR1_GREEN, 11);			/* Initialise green light for road 1 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&PD_LIGHT, 13);				/* Initialise pedestrian light */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_RED, 15);				/* Initialise red light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_YELLOW, 16);				/* Initialise yellow light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	status = XGpio_Initialize(&TR2_GREEN, 17);			/* Initialise green light for road 2 */
	if (status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
