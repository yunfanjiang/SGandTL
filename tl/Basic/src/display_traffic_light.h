/*
 * display_traffic_light.h
 *
 *  Created on: 6 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: display_traffic_light.h
 * Project Name: Basic Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 6 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.4.3
 *
 * Description:
 * Header file for "display_traffic_light.c".
 * Interface function: display_traffic_light ()				Called by: main function
 * Definitions for macros of colour and LED patterns are also included here.
 */

#ifndef DISPLAY_TRAFFIC_LIGHT_H_
#define DISPLAY_TRAFFIC_LIGHT_H_

/* Declaration for interface function */
extern void display_traffic_light (u8 state);

/* Definition for macros of colour */
#define COLOUR_WHITE	0xFFF
#define COLOUR_RED		0xF00
#define COLOUR_YELLOW	0xFF0
#define COLOUR_GREEN	0x0F0

/* Definition for macros of LED patterns */
#define LED_IDLE		0x0000					/* LED pattern for idle state */
#define LED_1R			0x8004					/* LED pattern when red light of road 1 turns on */
#define LED_1RY			0xC004					/* LED pattern when red and yellow lights of road 1 turn on */
#define LED_1G			0x2004					/* LED pattern when green light of road 1 turns on */
#define LED_1Y			0x4004					/* LED pattern when yellow light of road 1 turns on */
#define LED_2R			0x8004					/* LED pattern when red light of road 2 turns on */
#define LED_2RY			0x8006					/* LED pattern when red and yellow lights of road 2 turn on */
#define LED_2G			0x8001					/* LED pattern when green light of road 2 turns on */
#define LED_2Y			0x8002					/* LED pattern when yellow light of road 2 turns on */

#endif /* DISPLAY_TRAFFIC_LIGHT_H_ */
