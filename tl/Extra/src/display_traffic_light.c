/*
 * display_traffic_light.c
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: display_traffic_light.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.9.9
 *
 * Description:
 * Display_Module.
 * This module contains interface function "display_traffic_light ()".
 * Function "display_traffic_light ()" can map the states and corresponding traffic light patterns and display them.
 * Meanwhile, LED patterns to show the traffic light sequence will also be displayed by the function "display_traffic_light ()".
 * Furthermore, this function can display "all-off" mode and "emergency/warning" mode.
 * When in "all-off" mode, all lights will turn off, and word "oFF" will be displayed on the 7-segment display.
 * When in "emergency/warning" mode, all red lights will turn on, LEDs will shift continuously, and word "dAnG", which means "dangerous", will be displayed on the 7-segment display.
 * A "switch" statement is used to realize these functionalities.
 * It also depends on function "XGpio_DIscreteWrite ()", which is from the header file "xgpio.h", to colour VGA regions.
 */

#include "gpio_init.h"				/* Added for function DiscreteWrite */
#include "xil_types.h"				/* Added for type definition */
#include "read_PD_btn.h"			/* Added for interface variable "PD_Pressed_Flag" */
#include "display_traffic_light.h"	/* Added for colour definition and LED pattern definition */
#include "seg7_display.h"			/* Added for function "displayNumber ()" */
#include "master_control_module.h"	/* Added for interface variable "Warning_Flag" */
#include "led_shift.h"				/* Added for interface variable "ledValue" */

/* Definition for interface function */
/*
 * This interface function will be called in the main function.
 * It maps the states and corresponding traffic light patterns and displays them.
 * It also shows the sequence of traffic light by the LED patterns.
 * Special mode including "all-off" mode and "emergency/warning" mode can also be displayed.
 * Input "state" is the state that will be mapped and displayed.
 */
void display_traffic_light (u8 state)
{
	switch (state)
	{
	case 0x00:	/* Idle state, all lights turn down */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&LED_OUT, 1, LED_IDLE);
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x01:	/* Road1: red, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1R & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x02:	/* Road1: red & yellow, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1RY & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x03:	/* Road1: straight green, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1StrG & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x0C:	/* Road1: right-turn green, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1RightG & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x04:	/* Road1: yellow, road2: red, PD Light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_1Y & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x05:	/* Road1: red, road2: red, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2R & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x06:	/* Road1: red, road2: red & yellow, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2RY & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x07:	/* Road1: red, road2: straight green, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2StrG & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x0D:	/* Road1: red, road2: right-turn green, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2RightG & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GREEN);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x08:	/* Road1: red, road2: yellow, PD light: red */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_YELLOW);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* IF PD buttons are pressed, a LED will light up to indicate it */
		XGpio_DiscreteWrite (&LED_OUT, 1, ((PD_Pressed_Flag << 8) + (LED_2Y & 0xFEFF)));
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x0A:	/* The whole traffic light system turns off */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&LED_OUT, 1, 0);
		/* Three digits are required to display "oFF" on 7-segment displays */
		displayNumber (999);
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	case 0x0B:	/* Emergency mode, all red lights turn on */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_RED);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_RED);
		/* Four digits are required to display "dAnG" on 7-segment displays */
		displayNumber (9999);
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	break;

	default:	/* Idle state, all lights turn down */
		XGpio_DiscreteWrite (&TR1_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR1_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RED, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_YELLOW, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_STRAIGHT, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_STOP, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&LED_OUT, 1, LED_IDLE);
		XGpio_DiscreteWrite (&TR1_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&TR2_RIGHT_TURN, 1, COLOUR_GRAY);
		XGpio_DiscreteWrite (&PD_GO, 1, COLOUR_GRAY);
	}

	/* When in "emergency/warning" mode, i.e. the flag is active, the LEDs will shift continuously */
	if (Warning_Flag)
		XGpio_DiscreteWrite(&LED_OUT, 1, ledValue);
}
