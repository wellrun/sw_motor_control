/**
 * Module:  app_dsc_demo
 * Version: 1v0alpha1
 * Build:   dcbd8f9dde72e43ef93c00d47bed86a114e0d6ac
 * File:    outer_loop.xc
 * Modified by : Srikanth
 * Last Modified on : 04-May-2011
 *
 * The copyrights, all other intellectual and industrial 
 * property rights are retained by XMOS and/or its licensors. 
 * Terms and conditions covering the use of this code can
 * be found in the Xmos End User License Agreement.
 *
 * Copyright XMOS Ltd 2010
 *
 * In the case where this code is a modification of existing code
 * under a separate license, the separate license terms are shown
 * below. The modifications to the code are still covered by the 
 * copyright notice above.
 *
 **/                                   
#include <xs1.h>
#include <print.h>
#include "dsc_config.h"
#include "inner_loop.h"
#include "outer_loop.h"
#include "pid_regulator.h"
#include "watchdog.h"
#include "shared_io.h"

#define SEC 100000000

void speed_control_loop( chanend c_wd, chanend c_control_out, chanend c_display )
{
	unsigned ts, cmd;
	unsigned set_speed = INITIAL_SET_SPEED;
	unsigned speed = 0, pwm = 0, calced_pwm = 0 ;

	int iq = 0;
	int Torque = 0;

	timer t;

	//int Kp= (32000 * 10), Ki=4000, Kd=1000;
	//int Kp= 8000, Ki=250, Kd=0;
	//int Kp= 32000, Ki=0, Kd=0;
	//int Kp= 7000;
	//int Ki=20;
	//int Kd=0;
	//pid_data pid;

	//init_pid( Kp, Ki, Kd, pid );

	/* delay to allow the WD to get going */
	t :> ts;
	t when timerafter(ts+SEC) :> ts;
	
	// enable motor via watchdog
	c_wd <: WD_CMD_START;	
	
	// Get the initial timer values
	t :> ts;

	/* initialise speed setting */
	set_speed = 2000;

	// Loop forever running the main control loop
	while (1)
	{
		#pragma ordered
		select
		{
			case t when timerafter (ts + 100000) :> ts: /* Run the main control loop at 6kHz */
				/* Gets the speed from qei thread */
			//	c_control_out <: 1;
			//	c_control_out :> speed;

				/* speed in terms of 14 bit */
				//set_speed += 100;

			//	if(set_speed >= 2000)
			// 		set_speed = 2000;
				calced_pwm =  (set_speed * PWM_MAX_VALUE) / (166*24);

				//speed *= 4;
				//set_speed *= 4;

				/* calculate required torque */
			//	Torque = pid_regulator_delta_cust_error1((int)(set_speed - speed), pid );
#if 0
				pwm = calced_pwm + Torque;//pid_regulator_delta_cust_error((int)(set_speed - speed), pid );
				if (pwm > 4000)
					pwm = 4000;
				if (pwm < 20)
					pwm = 20;
				pwm = (unsigned)pwm;
#endif
				//Torque = pid_regulator((int)set_speed, (int)speed, pid);

				/* iq to Torque conversion */
				iq = Torque ;
				//c_control_out <: 0;
				//c_control_out <: iq;
			//	c_control_out <: pwm;

				//speed /= 4;
				//set_speed /= 4;

				break;

			case c_display :> cmd: /* Process a command received from the display */
				if (cmd == CMD_GET_IQ)
				{
					c_display <: set_speed;
					//c_display <: set_speed;
				}
				else if (cmd == CMD_SET_SPEED)
				{
					c_display :> set_speed;
				}
				else
				{
					// Ignore invalid command
				}

				break;

			default:

				break;
		}
	}
}
