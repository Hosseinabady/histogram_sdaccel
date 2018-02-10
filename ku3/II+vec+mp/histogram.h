/* File: histogram.h
 *
 Copyright (c) [2016] [Mohammad Hosseinabady (mohammad@hosseinabady.com)]
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
===============================================================================
* This file has been written at University of Bristol
* for the ENPOWER project funded by EPSRC
*
* File name : histogram.h
* author    : Mohammad hosseinabady mohammad@hosseinabady.com
* date      : 1 October 2017
* blog: https://highlevel-synthesis.com/
*/
#ifndef __VECTOR_ADDITION_h__
#define __VECTOR_ADDITION_h__


typedef unsigned long int u32;

#define DATA_LENGTH  (2048*2084*8/4)


#define INPUT_DATA_TYPE    int
#define BIN_DATA_TYPE      int

#define DATA_TYPE1   int
#define DATA_TYPE16  int16

#define PIPE_DEPTH   512

#define NO_OF_PORTS   2


#define BIN_SIZE 256


struct u32_unsigned_char_data{
	unsigned char a[4];
};
typedef union wide_data_type{
	struct u32_unsigned_char_data unsigned_char_data;
	u32                              data;

}WIDE_DATA_TYPE;



#endif // __VECTOR_ADDITION_h__
