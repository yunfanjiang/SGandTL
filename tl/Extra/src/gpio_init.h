/*
 * gpio_init.h
 *
 *  Created on: 4 Nov 2018
 *      Author: s1886282
 */

/*
 * File Name: gpio_init.h
 * Project Name: Extra Traffic Light
 * Target Device/Platform: Basys3 Board (with MICROBLAZE processor on the ARTIX-7 FPGA)
 * Tool Version: XILINX SDK 2015.2
 * Author: Yunfan Jiang (s1886282)
 * Company: School of Engineering, The University of Edinburgh
 * Created on: 4 Nov 2018
 * Last edited on: 14 Nov 2018
 * Version: 1.3.2
 *
 * Description:
 * Header file for "gpio_init.c".
 * Function "initGPio", which can initialise XGpio objects, and XGpio objects, which will be used by other modules,
 * are declared in this header file.
 */

#ifndef GPIO_INIT_H_
#define GPIO_INIT_H_

#include "xgpio.h"

/* Declaration for function "initGpio". This function can be used to initialise XGpio objects. */
extern XStatus initGpio (void);

/* Declaration for XGpio objects, which will be used by other modules to control the hardware. */
XGpio SEG7_HEX_OUT;
XGpio SEG7_SEL_OUT;
XGpio LED_OUT;
XGpio P_BTN_UP;
XGpio P_BTN_DOWN;
XGpio P_BTN_LEFT;
XGpio TR1_RED;
XGpio TR1_YELLOW;
XGpio TR1_STRAIGHT;
XGpio PD_STOP;
XGpio TR2_RED;
XGpio TR2_YELLOW;
XGpio TR2_STRAIGHT;
XGpio SlideSwitches;
XGpio TR1_RIGHT_TURN;
XGpio TR2_RIGHT_TURN;
XGpio PD_GO;

#endif /* GPIO_INIT_H_ */
