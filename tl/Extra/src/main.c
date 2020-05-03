/*
 * main.c
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: main.c
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.3.2
 *
 * Description:
 * An advanced UK traffic light system is developed, which can be applied in busy junctions and under complex situations.
 * The advanced system has all functionalities that the basic system has.
 * Meanwhile, in this system, green lights are divided into straight light and right-turn light to guide vehicles to go straight or turn right.
 * Furthermore, if the junction is not used and all lights need to be turned off, this advanced system can be controlled into "all-off" mode.
 * If there are accidents or emergencies happening, the whole system can go to "emergency/warning" mode to indicate the warning signal.
 * The displaying time for each lights also can be adjusted for higher applicability under different circumstances.
 * Based on the modified hardware, the pedestrian light is much more pedestrian-friendly. It can display word "STOP" and "GO"
 * for the convenience of individuals who have problems to distinguish colours.
 * The various functionalities and high practicability make the advanced system more applicable for the real life.
 *
 * A detailed hierarchy chart is given below to show the file structure.
 *
											   +-----------------+
											   |                 |
											   |      main.c     |
											   |                 |
											   +------,,-.,------+
											   _,.-'``     ``'-.,
										_,.-'``                  ``'-.,
							  +-------``---+                       +---``'------+
							  |  traffic_  |                       |   display_ |
							  |light_state_|                       |   traffic_ |
							  | machine.c  |                       |   light.c  |
							  |            |                       |            |
							  +------------+                       +------/-----+
								  ,' `.                                   |
								 -     ',                                 |
							   ,'        \                                |
							 ,'           `.                              |
							-               ',                            |
					 +-----`----+       +-----'----+                 +----\-----+
					 | read_PD_ |       |delay_and_|                 |   seg7_  |
					 |  btn.c   |       | blink.c  |                 | display.c|
					 |          |       |          |                 |          |
					 +----------+       +------,---+                 +----------+
										   ,-`  ',
										 .'       ',
									  _-`           `.
									,'                `.
						   +-------`-----+        +-----`'------+
						   |   master_   |        |             |
						   |   control_  |        | led_shift.c |
						   |   module.c  |        |             |
						   |             |        |             |
						   +-------------+        +-------------+
 * Note that the whole project depends on file "gpio_init.c", "xinterruptES3.c" and other hardware support files.
 */

#include <stdio.h>
#include "platform.h"
#include "gpio_init.h"						/* Added for XGpio objects and initialisation */
#include "xil_types.h"						/* Added for type definition */
#include "xinterruptES3.h"					/* Added for function to initialise ISR */
#include "delay_and_blink.h"				/* Added for interface variable "output_state" */
#include "traffic_light_state_machine.h"	/* Added for interface function "traffic_light_SM ()" */
#include "display_traffic_light.h"			/* Added for interface function "display_traffic_light ()" */

int main()
{
    init_platform();
	int status;

    status = initGpio();					/* Initialise the GPIOs */
	if (status != XST_SUCCESS) {
		print("GPIOs initialisation failed!\n\r");
		cleanup_platform();
		return 0;
	}

    status = setUpInterruptSystem();		/* Initialise the ISR */
    if (status != XST_SUCCESS) {
        print("Interrupt system setup failed!\n\r");
        cleanup_platform();
        return 0;
    }


	while (1)
	{
		/* Call the Traffic_Light_State_Machine, through which the state will change automatically */
		traffic_light_SM ();

		/* Display the traffic light on the monitor and show LED patterns, remaining time, and other information on the FPGA board */
		display_traffic_light (output_state);
	}

    cleanup_platform();
    return 0;
}
