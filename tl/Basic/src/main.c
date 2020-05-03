/*
 * main.c
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: main.c
 * Project Name: Basic Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 15 Nov 2018
 * Version: 1.3.2
 *
 * Description:
 * A UK traffic light system is developed in this project.
 * This system can be applied to a T-junction road, which contains two roads and three pedestrian crossings.
 * The road 1 has the priority. When there are no pedestrians, the traffic lights will direct the traffic of the two roads.
 * After pedestrians pressing the buttons, they have to wait until both traffic lights change to red then they can go.
 * After pedestrians finish crossing, the traffic lights will return to normal operation.
 *
 * A hierarchy chart to show the file structure is given below.
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
						 +----------+       +----------+                 +----------+
 * Note that the whole project is based on file "gpio_init.c", "xinterruptES3.c" and other hardware support files.
 */

#include <stdio.h>
#include "platform.h"
#include "gpio_init.h"						/* Added for XGpio objects and initialisation */
#include "xil_types.h"						/* Added for type definition */
#include "xinterruptES3.h"					/* Added for function to initialise ISR */
#include "traffic_light_state_machine.h"	/* Added for interface function "traffic_light_SM ()" */
#include "display_traffic_light.h"			/* Added for interface function "display_traffic_light ()" */
#include "delay_and_blink.h"				/* Added for interface variable "output_state" */

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
		traffic_light_SM ();					/* Call the Traffic_Light_State_Machine, which will change the state automatically */

		display_traffic_light (output_state);	/* Display the traffic light on the monitor */
	}

    cleanup_platform();
    return 0;
}
