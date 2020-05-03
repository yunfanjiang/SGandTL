/*
 * master_control_module.h
 *
 *  Created on: 8 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: master_control_module.h
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
 * Header file for "master_control_module.c".
 * Interface variables:
 * All_Off_FLag			Accessed by: 7-segment display
 * Warning_FLag			Accessed by: 7-segment display and Display_Module
 * Light_period			Accessed by: Delay_and_Blink_Module
 * PD_Period			Accessed by: Delay_and_Blink_Module
 * Interface function:
 * master_control ()	Called by: Delay_and_Blink_Module
 */

#ifndef MASTER_CONTROL_MODULE_H_
#define MASTER_CONTROL_MODULE_H_

/* Declaration for interface variables */
extern int All_Off_Flag;
extern int Warning_Flag;
extern int Light_Period;
extern int PD_Period;

/*Declaration for interface function */
extern void master_control ();

#endif /* MASTER_CONTROL_MODULE_H_ */
