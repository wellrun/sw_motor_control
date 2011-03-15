/**
 * Module:  module_dsc_blocks
 * Version: 1v0alpha1
 * Build:   7b7eef1756b9212fbbec0f46dcf20389c3e60ffd
 * File:    frac_mul.xc
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
#include "pid_regulator.h"

int frac_mul( int a, int b )
{
	int h;
	unsigned l;

	{h,l} = macs(a,b,0,0);

	l >>= PID_RESOLUTION;
	l |= h << (32-PID_RESOLUTION);
	return l;
}