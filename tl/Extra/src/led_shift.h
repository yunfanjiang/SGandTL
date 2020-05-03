/*
 * led_shift.h
 *
 *  Created on: 9 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: led_shift.h
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 9 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.1.1
 *
 * Description:
 * Header file for "led_shift.c".
 * Interface variable: ledValue					Accessed by: Display_Module
 * Interface function: LED_Shift ()				Called by: ISR function
 */

#ifndef LED_SHIFT_H_
#define LED_SHIFT_H_

/* Declaration for interface variable */
extern u16 ledValue;

/* Declaration for interface function */
extern void LED_Shift ();

#endif /* LED_SHIFT_H_ */
