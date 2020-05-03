/*
 * master_control_module.c
 *
 *  Created on: 8 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: master_control_module.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 8 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.3.1
 *
 * Description:
 * This file includes interface function "master_control ()", which will be called by Delay_and_Blink_Module.
 * This function controls the behaviour of the traffic light system at the highest level.
 * Three modes, normal mode, "all-off" mode, and "emergency/warning" mode, can be chosen by slide switches.
 * Meanwhile, the displaying time for each light can be controlled for higher applicability.
 * The first priority is given to "all-off" mode, then the second priority is given to "emergency/warning" mode,
 * i.e., when the system is not in "all-off" mode, it can be controlled into "emergency/warning" mode.
 * When the system is in normal operation, the displaying time for each light can be adjusted.
 * A detailed function table is given below.
 *
 * 													Function Table
 * 	All-off, Emergency, PD period, Traffic light period			Function
 * 		1		x			x				xx					All-off
 * 		0		1			x				xx					Emergency/warning
 * 		0		0			0				00					Normal operation (Traffic light: 2s, PD light: 5s)
 * 		0		0			0				01					Normal operation (Traffic light: 4s, PD light: 5s)
 * 		0		0			0				10					Normal operation (Traffic light: 6s, PD light: 5s)
 * 		0		0			0				11					Normal operation (Traffic light: 8s, PD light: 5s)
 * 		0		0			1				00					Normal operation (Traffic light: 2s, PD light: 10s)
 * 		0		0			1				01					Normal operation (Traffic light: 4s, PD light: 10s)
 * 		0		0			1				10					Normal operation (Traffic light: 6s, PD light: 10s)
 * 		0		0			1				11					Normal operation (Traffic light: 8s, PD light: 10s)
 */

#include "gpio_init.h"	/* Added for XGpio objects */

/* Definition for interface variables */
int All_Off_Flag;	/* Accessed by 7-segment display */
int Warning_Flag;	/* Accessed by 7-segment display and Display_Module */
int Light_Period;	/* Accessed by Delay_and_Blink_Module */
int PD_Period;		/* Accessed by Delay_and_Blink_Module */

/* Definition for interface function */
/* This interface function will be called in Delay_and_Blink_Module */
/* This function reads the value from slide switches and determines the operation mode of the system */
void master_control ()
{
	/* Declare intermediate variable */
	u16 slideSwitchIn;
	/* Read the value of slide switches */
	slideSwitchIn = XGpio_DiscreteRead (&SlideSwitches, 1);

	/* Switch statement is used to select operation mode */
	switch (((slideSwitchIn & 0xC000) >> 11 ) + (slideSwitchIn & 0x0007))
	{
	case 0x00:	/* Normal operation (Traffic light: 2s, PD light: 5s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period	 = 1;
	break;

	case 0x01:	/* Normal operation (Traffic light: 4s, PD light: 5s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 2;
		PD_Period	 = 1;
	break;

	case 0x02:	/* Normal operation (Traffic light: 6s, PD light: 5s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 3;
		PD_Period	 = 1;
	break;

	case 0x03:	/* Normal operation (Traffic light: 8s, PD light: 5s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 4;
		PD_Period	 = 1;
	break;

	case 0x04:	/* Normal operation (Traffic light: 2s, PD light: 10s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period	 = 2;
	break;

	case 0x05:	/* Normal operation (Traffic light: 4s, PD light: 10s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 2;
		PD_Period	 = 2;
	break;

	case 0x06:	/* Normal operation (Traffic light: 6s, PD light: 10s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 3;
		PD_Period	 = 2;
	break;

	case 0x07:	/* Normal operation (Traffic light: 8s, PD light: 10s) */
		All_Off_Flag = 0;
		Warning_Flag = 0;
		Light_Period = 4;
		PD_Period	 = 2;
	break;

	case 0x08:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x09:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0A:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0B:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0C:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0D:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0E:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x0F:	/* Emergency/warning mode */
		All_Off_Flag = 0;
		Warning_Flag = 1;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x10:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x11:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x12:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x13:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x14:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x15:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x16:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x17:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x18:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x19:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1A:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1B:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1C:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1D:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1E:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	case 0x1F:	/* All-off mode */
		All_Off_Flag = 1;
		Warning_Flag = 0;
		Light_Period = 1;
		PD_Period    = 1;
	break;

	}
}
