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
//
//#define DATA_LENGTH  (2048*32)
#define DATA_LENGTH  (12304 * 8128/4)
//(2048*2048*8/4)
//#define DATA_LENGTH  (2048*32)



typedef unsigned int  u32;
typedef unsigned char u8;
//typedef u8         DATA_TYPE;
typedef u32         DATA_TYPE;

//#define DATA_LENGTH_MAX (1024*1024*64)
#define BIN_LENGTH   256



#endif // __VECTOR_ADDITION_h__
