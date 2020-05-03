/*
 * read_PD_btn.h
 *
 *  Created on: 4 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: read_PD_btn.h
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
 * Header file for "read_PD_btn.c".
 * Interface variable: PD_Pressed_Flag			Accessed and changed by: State_Machine_Module and Display_Module
 * Interface function: read_btn ()				Called by: Delay_and_Blink_Module
 */

#ifndef READ_PD_BTN_H_
#define READ_PD_BTN_H_

/* Declaration for interface variable*/
extern int PD_Pressed_Flag;

/* Declaration for interface function */
extern void read_btn ();

#endif /* READ_PD_BTN_H_ */
