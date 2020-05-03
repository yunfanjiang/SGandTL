/*
 * This file is from the support materials of Engineering Software 3 Laboratory 3.
 * Used by: Yunfan Jiang (s1886282)
 * Used on: 9 Nov 2018
 */

#include "xil_types.h"  // Added for integer type definitions
#include "limits.h"     // Added for CHAR_BIT definition

u16 rotateLeft(u16 value, u8 shift)
{
    return (value << shift) | (value >> (sizeof(value) * CHAR_BIT - shift));
}

u16 rotateRight(u16 value, u8 shift)
{
    return (value >> shift) | (value << (sizeof(value) * CHAR_BIT - shift));
}
