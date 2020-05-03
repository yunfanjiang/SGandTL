/*
 * read_PD_btn.c
 *
 *  Created on: 4 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: read_PD_btn.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 4 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.2.2
 *
 * Description:
 * Read_Pedestrian_Button_Module.
 * This module contains interface function "read_btn ()" and interface variable "PD_Pressed_Flag".
 * Function "read_btn ()" can detect the pedestrian buttons being pressed.
 * Meanwhile, it will activate the flag when the buttons are pressed.
 */

#include "gpio_init.h"	/* Added for XGpio objects */
#include "xil_types.h"	/* Added for variable types */

/* Definition for interface variable */
/* This interface will be accessed and changed by State_Machine_Module and Display_Module */
int PD_Pressed_Flag = 0;

/* Definition for interface function */
/*
 * This function will be called by Delay_and_Blink_Module.
 * It detects the press action and returns an active flag when pedestrian buttons are pressed.
 */
void read_btn ()
{
	/* Declare the intermediate variables */
	u16 pushBtnLeftIn;
	u16 pushBtnUpIn;
	u16 pushBtnDownIn;

	/* Press action will be detected only when the buttons are not pressed before */
	if (PD_Pressed_Flag == 0)
	{
		pushBtnLeftIn = XGpio_DiscreteRead(&P_BTN_LEFT, 1);	/* Check if the left PD button being pressed */
		pushBtnUpIn = XGpio_DiscreteRead(&P_BTN_UP, 1);		/* Check if the up PD button being pressed */
		pushBtnDownIn = XGpio_DiscreteRead(&P_BTN_DOWN, 1);	/* Check if the down PD button being pressed */

		if (pushBtnLeftIn | pushBtnUpIn | pushBtnDownIn)	/* Any one button is pressed, the flag will be activated */
			PD_Pressed_Flag = 1;
	}
}
