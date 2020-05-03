/*
 * delay_and_blink.h
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: delay_and_blink.h
 * Project Name: Basic Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.3.3
 *
 * Description:
 * Header file for "delay_and_blink.c".
 * Interface variable: output_state				Accessed by: Display_Module
 * Interface function: delay_timer ()			Called by: State_Machine_Module
 * Interface function: bliknk_PD ()				Called by: State_Machine_Module
 */

#ifndef DELAY_AND_BLINK_H_
#define DELAY_AND_BLINK_H_

#include "xil_types.h"

/* Declaration for interface variable */
extern u16 output_state;

/* Declaration for interface functions */
extern void delay_timer (int period, u8 state);
extern void blink_PD ();


#endif /* DELAY_AND_BLINK_H_ */
