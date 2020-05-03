/*
 * display_traffic_light.c
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: display_traffic_light.c
 * Project Name: Basic Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.5.7
 *
 * Description:
 * Display_Module.
 * This module contains interface function "display_traffic_light ()".
 * This function can map the states and corresponding traffic light patterns and display them.
 * Meanwhile, LED patterns to show the traffic light sequence will also be displayed by this function.
 * A "switch" statement is used to realize these functionalities.
 * It also depends on function "XGpio_DiscreteWrite ()", which is from header file "xgpio.h", to colour the VGA regions.
 */

#include "gpio_init.h"				/* Added for function DiscreteWrite */
#include "xil_types.h"				/* Added for type definition */
#include "read_PD_btn.h"			/* Added for interface variable "PD_Pressed_Flag" */
#include "display_traffic_light.h"	/* Added for colour definition and LED pattern definition*/

/* Definition for interface function */
/*
 * This interface function will be called in the main function.
 * It maps the states and corresponding traffic light patterns and displays them.
 * It also shows the sequence of traffic light by the LED patterns.
 * Input "state" is the state that will be mapped and displayed.
 */
void display_traffic_light (u8 state)
{
	switch (state)
	{
	case 0x00:	/* Idle state, all lights turn down */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&LED_OUT, 1, LED_IDLE);
	break;

	case 0x01:	/* Road1: red, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1R & 0xFEFF)));
	break;

	case 0x02:	/* Road1: red & yellow, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1RY & 0xFEFF)));
	break;

	case 0x03:	/* Road1: green, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1G & 0xFEFF)));
	break;

	case 0x04:	/* Road1: yellow, road2: red, PD Light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1Y & 0xFEFF)));
	break;

	case 0x05:	/* Road1: red, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2R & 0xFEFF)));
	break;

	case 0x06:	/* Road1: red, road2: red & yellow, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2RY & 0xFEFF)));
	break;

	case 0x07:	/* Road1: red, road2: green, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2G & 0xFEFF)));
	break;

	case 0x08:	/* Road1: red, road2: yellow, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_RED);
		/* When pedestrian buttons are pressed, a LED will indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2Y & 0xFEFF)));
	break;

	default:		/* Idle state, all lights turn down */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR1_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&TR2_GREEN, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&PD_LIGHT, 1, COLOUR_WHITE);
		XGpio_DiscreteWrite (&LED_OUT, 1, LED_IDLE);
	}
}
