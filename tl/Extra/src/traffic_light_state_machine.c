/*
 * traffic_light_state_machine.c
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: traffic_light_state_machine.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.5.6
 *
 * Description:
 * State_Machine_Module.
 * The behaviour of traffic light is determined by a state machine in this file.
 * Fourteen states are defined in the state machine, including one idle state, one state for pedestrians going,
 * ten states for traffic lights of two roads, one state for "all-off" mode, and one state for "emergency/warning" mode.
 * A detailed state table is given below.
 *
 * 									State Table
 * 				State Code							State Name
 * 				0x00								Idle state
 * 				0x01								Road 1: red
 * 				0x02								Road 1: red & yellow
 * 				0x03								Road 1: straight green
 * 				0x04								Road 1: yellow
 * 				0x05								Road 2: red
 * 				0x06								Road 2: red & yellow
 * 				0x07								Road 2: straight green
 * 				0x08								Road 2: yellow
 * 				0x09								Pedestrians go
 * 				0x0A								All-off
 * 				0x0B								Emergency/warning
 * 				0x0C								Road 1: right-turn green
 * 				0x0D								Road 2: right-turn green
 */

#include "xil_types.h"				/* Added for type definition */
#include "read_PD_btn.h"			/* Added for interface variable "PD_Pressed_Flag" */
#include "delay_and_blink.h"		/* Added for interface functions "delay_timer ()" and "blink_PD ()" */
#include "master_control_module.h"	/* Added for interface variables "All_Off_Flag" and "Warning_Flag"

/* Definition for interface function */
/* This interface function will be called in the main function.
 * This function determines the logic and behaviour of traffic lights by a state machine.
 * It can self-start from idle state.
 */
void traffic_light_SM ()
{
	u8 curr_state;	/* The current state for the traffic light */

	master_control ();
	if ((All_Off_Flag == 0) & (Warning_Flag == 0))
	{
		/* Switch statement is used to change states */
		switch (curr_state)
		{
		case 0x00:		/* Idle state */
			curr_state = 0x01;
		break;

		case 0x01:		/* Road1: red, road2: red, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x02;
		break;

		case 0x02:		/* Road1: red & yellow, road2: red, PD light: red */
			delay_timer (2, curr_state);

			/* Pedestrians can go only when two roads' red lights turn on */
			if (PD_Pressed_Flag == 1)
				curr_state = 0x09;
			else
				curr_state = 0x03;
		break;

		case 0x03:		/* Road1: straight green, road2: red, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x0C;
		break;

		case 0x0C:		/* Road1: right-turn green, road2: red, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x04;
		break;

		case 0x04:		/* Road1: yellow, road2: red, PD Light: red */
			delay_timer (2, curr_state);
			curr_state = 0x05;
		break;

		case 0x05:		/* Road1: red, road2: red, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x06;
		break;

		case 0x06:		/* Road1: red, road2: red & yellow, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x07;
		break;

		case 0x07:		/* Road1: red, road2: straight green, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x0D;
		break;

		case 0x0D:		/* Road1: red, road2: right-turn green, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x08;
		break;

		case 0x08:		/* Road1: red, road2: yellow, PD light: red */
			delay_timer (2, curr_state);
			curr_state = 0x01;
		break;

		case 0x09:		/* Pedestrians go! Road 1 & road 2: red */
			curr_state = 0x03;
			blink_PD ();
		break;

		default:		/* Default state is the idle state */
			curr_state = 0x00;
		}
	}
	/* Check if the system is controlled into "all-off" operation */
	else if ((All_Off_Flag == 1) & (Warning_Flag == 0))
	{
		output_state = 0x0A;
		curr_state = 0x02;
	}
	/* If the system is not in neither "all-off" operation nor normal operation, then goes to "emergency/warning" operation */
	else
	{
		output_state = 0x0B;
		curr_state = 0x02;
	}
}
