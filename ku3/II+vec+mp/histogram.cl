/* File: histogram.cl
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
* File name : histogram.cl
* author    : Mohammad hosseinabady mohammad@hosseinabady.com
* date      : 1 October 2017
* blog: https://highlevel-synthesis.com/
*/

#include "histogram.h"



#define VECTOR_TYPE_LENGTH 16
#define VECTOR_DATA_TYPE DATA_TYPE16

pipe  VECTOR_DATA_TYPE pdata_0 __attribute__((xcl_reqd_pipe_depth(PIPE_DEPTH)));
pipe  VECTOR_DATA_TYPE pdata_1 __attribute__((xcl_reqd_pipe_depth(PIPE_DEPTH)));




__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
read_data_kernel_0(__global VECTOR_DATA_TYPE* vectorData_0, int data_length) {

	data_length = DATA_LENGTH/NO_OF_PORTS;
	int global_index;

	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i+=VECTOR_TYPE_LENGTH) {
		global_index =   i;
		global_index /= VECTOR_TYPE_LENGTH;
		VECTOR_DATA_TYPE d = vectorData_0[global_index];
		write_pipe_block(pdata_0, &d);
	}
}

__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
read_data_kernel_1(__global VECTOR_DATA_TYPE* vectorData_1, int data_length) {
	data_length = DATA_LENGTH/NO_OF_PORTS;
	int global_index;

	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i+=VECTOR_TYPE_LENGTH) {
		global_index =   i;
		global_index /= VECTOR_TYPE_LENGTH;
		VECTOR_DATA_TYPE d = vectorData_1[global_index];
		write_pipe_block(pdata_1, &d);
	}
}



  __kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
compute_data_histogram_kernel(int data_length, int bin_size, __global int *Hist) {

	  bin_size = BIN_SIZE;
	  data_length = DATA_LENGTH;


	BIN_DATA_TYPE  hist_private[NO_OF_PORTS*4*4*VECTOR_TYPE_LENGTH][BIN_SIZE] __attribute__((xcl_array_partition(complete, 1)));



	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < bin_size; i++) {
		for (int j = 0; j < NO_OF_PORTS*4*4*VECTOR_TYPE_LENGTH; j++) {
			hist_private[j][i] = 0;
		}
	}

	VECTOR_DATA_TYPE d[4*NO_OF_PORTS] __attribute__((xcl_array_partition(complete, 1)));
	WIDE_DATA_TYPE wide_data[4*NO_OF_PORTS]  __attribute__((xcl_array_partition(complete, 1)));


	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i += NO_OF_PORTS*4*VECTOR_TYPE_LENGTH) {

		for (int k = 0; k < 4*NO_OF_PORTS; k+=2) {
			read_pipe_block(pdata_0, &d[k+0]);
			read_pipe_block(pdata_1, &d[k+1]);
		}


		wide_data[0].data = d[0].s0;
		hist_private[0][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[1][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[2][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[3][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s0;
		hist_private[4][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[5][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[6][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[7][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s0;
		hist_private[8][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[9][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[10][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[11][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s0;
		hist_private[12][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[13][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[14][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[15][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s0;
		hist_private[16][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[17][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[18][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[19][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s0;
		hist_private[20][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[21][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[22][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[23][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s0;
		hist_private[24][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[25][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[26][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[27][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s0;
		hist_private[28][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[29][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[30][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[31][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s1;
		hist_private[32][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[33][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[34][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[35][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s1;
		hist_private[36][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[37][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[38][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[39][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s1;
		hist_private[40][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[41][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[42][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[43][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s1;
		hist_private[44][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[45][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[46][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[47][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s1;
		hist_private[48][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[49][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[50][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[51][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s1;
		hist_private[52][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[53][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[54][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[55][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s1;
		hist_private[56][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[57][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[58][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[59][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s1;
		hist_private[60][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[61][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[62][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[63][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s2;
		hist_private[64][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[65][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[66][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[67][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s2;
		hist_private[68][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[69][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[70][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[71][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s2;
		hist_private[72][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[73][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[74][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[75][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s2;
		hist_private[76][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[77][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[78][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[79][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s2;
		hist_private[80][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[81][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[82][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[83][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s2;
		hist_private[84][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[85][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[86][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[87][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s2;
		hist_private[88][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[89][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[90][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[91][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s2;
		hist_private[92][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[93][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[94][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[95][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s3;
		hist_private[96][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[97][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[98][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[99][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s3;
		hist_private[100][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[101][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[102][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[103][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s3;
		hist_private[104][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[105][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[106][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[107][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s3;
		hist_private[108][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[109][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[110][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[111][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s3;
		hist_private[112][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[113][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[114][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[115][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s3;
		hist_private[116][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[117][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[118][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[119][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s3;
		hist_private[120][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[121][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[122][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[123][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s3;
		hist_private[124][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[125][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[126][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[127][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s4;
		hist_private[128][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[129][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[130][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[131][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s4;
		hist_private[132][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[133][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[134][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[135][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s4;
		hist_private[136][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[137][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[138][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[139][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s4;
		hist_private[140][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[141][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[142][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[143][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s4;
		hist_private[144][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[145][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[146][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[147][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s4;
		hist_private[148][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[149][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[150][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[151][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s4;
		hist_private[152][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[153][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[154][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[155][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s4;
		hist_private[156][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[157][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[158][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[159][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s5;
		hist_private[160][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[161][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[162][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[163][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s5;
		hist_private[164][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[165][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[166][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[167][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s5;
		hist_private[168][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[169][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[170][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[171][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s5;
		hist_private[172][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[173][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[174][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[175][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s5;
		hist_private[176][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[177][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[178][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[179][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s5;
		hist_private[180][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[181][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[182][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[183][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s5;
		hist_private[184][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[185][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[186][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[187][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s5;
		hist_private[188][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[189][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[190][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[191][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s6;
		hist_private[192][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[193][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[194][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[195][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s6;
		hist_private[196][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[197][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[198][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[199][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s6;
		hist_private[200][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[201][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[202][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[203][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s6;
		hist_private[204][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[205][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[206][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[207][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s6;
		hist_private[208][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[209][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[210][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[211][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s6;
		hist_private[212][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[213][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[214][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[215][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s6;
		hist_private[216][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[217][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[218][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[219][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s6;
		hist_private[220][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[221][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[222][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[223][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s7;
		hist_private[224][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[225][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[226][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[227][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s7;
		hist_private[228][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[229][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[230][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[231][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s7;
		hist_private[232][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[233][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[234][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[235][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s7;
		hist_private[236][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[237][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[238][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[239][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s7;
		hist_private[240][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[241][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[242][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[243][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s7;
		hist_private[244][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[245][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[246][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[247][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s7;
		hist_private[248][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[249][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[250][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[251][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s7;
		hist_private[252][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[253][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[254][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[255][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s8;
		hist_private[256][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[257][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[258][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[259][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s8;
		hist_private[260][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[261][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[262][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[263][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s8;
		hist_private[264][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[265][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[266][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[267][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s8;
		hist_private[268][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[269][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[270][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[271][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s8;
		hist_private[272][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[273][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[274][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[275][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s8;
		hist_private[276][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[277][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[278][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[279][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s8;
		hist_private[280][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[281][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[282][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[283][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s8;
		hist_private[284][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[285][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[286][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[287][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s9;
		hist_private[288][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[289][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[290][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[291][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s9;
		hist_private[292][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[293][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[294][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[295][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s9;
		hist_private[296][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[297][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[298][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[299][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s9;
		hist_private[300][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[301][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[302][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[303][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].s9;
		hist_private[304][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[305][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[306][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[307][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].s9;
		hist_private[308][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[309][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[310][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[311][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].s9;
		hist_private[312][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[313][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[314][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[315][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].s9;
		hist_private[316][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[317][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[318][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[319][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sa;
		hist_private[320][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[321][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[322][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[323][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sa;
		hist_private[324][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[325][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[326][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[327][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sa;
		hist_private[328][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[329][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[330][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[331][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sa;
		hist_private[332][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[333][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[334][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[335][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].sa;
		hist_private[336][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[337][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[338][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[339][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].sa;
		hist_private[340][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[341][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[342][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[343][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].sa;
		hist_private[344][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[345][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[346][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[347][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].sa;
		hist_private[348][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[349][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[350][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[351][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sb;
		hist_private[352][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[353][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[354][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[355][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sb;
		hist_private[356][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[357][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[358][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[359][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sb;
		hist_private[360][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[361][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[362][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[363][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sb;
		hist_private[364][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[365][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[366][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[367][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].sb;
		hist_private[368][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[369][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[370][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[371][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].sb;
		hist_private[372][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[373][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[374][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[375][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].sb;
		hist_private[376][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[377][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[378][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[379][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].sb;
		hist_private[380][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[381][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[382][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[383][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sc;
		hist_private[384][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[385][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[386][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[387][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sc;
		hist_private[388][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[389][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[390][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[391][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sc;
		hist_private[392][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[393][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[394][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[395][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sc;
		hist_private[396][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[397][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[398][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[399][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].sc;
		hist_private[400][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[401][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[402][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[403][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].sc;
		hist_private[404][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[405][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[406][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[407][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].sc;
		hist_private[408][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[409][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[410][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[411][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].sc;
		hist_private[412][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[413][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[414][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[415][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sd;
		hist_private[416][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[417][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[418][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[419][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sd;
		hist_private[420][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[421][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[422][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[423][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sd;
		hist_private[424][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[425][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[426][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[427][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sd;
		hist_private[428][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[429][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[430][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[431][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].sd;
		hist_private[432][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[433][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[434][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[435][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].sd;
		hist_private[436][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[437][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[438][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[439][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].sd;
		hist_private[440][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[441][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[442][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[443][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].sd;
		hist_private[444][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[445][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[446][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[447][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].se;
		hist_private[448][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[449][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[450][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[451][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].se;
		hist_private[452][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[453][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[454][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[455][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].se;
		hist_private[456][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[457][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[458][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[459][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].se;
		hist_private[460][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[461][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[462][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[463][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].se;
		hist_private[464][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[465][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[466][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[467][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].se;
		hist_private[468][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[469][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[470][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[471][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].se;
		hist_private[472][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[473][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[474][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[475][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].se;
		hist_private[476][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[477][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[478][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[479][wide_data[7].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sf;
		hist_private[480][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[481][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[482][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[483][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sf;
		hist_private[484][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[485][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[486][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[487][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sf;
		hist_private[488][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[489][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[490][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[491][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sf;
		hist_private[492][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[493][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[494][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[495][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[4].data = d[4].sf;
		hist_private[496][wide_data[4].unsigned_char_data.a[0]]++;
		hist_private[497][wide_data[4].unsigned_char_data.a[1]]++;
		hist_private[498][wide_data[4].unsigned_char_data.a[2]]++;
		hist_private[499][wide_data[4].unsigned_char_data.a[3]]++;
		wide_data[5].data = d[5].sf;
		hist_private[500][wide_data[5].unsigned_char_data.a[0]]++;
		hist_private[501][wide_data[5].unsigned_char_data.a[1]]++;
		hist_private[502][wide_data[5].unsigned_char_data.a[2]]++;
		hist_private[503][wide_data[5].unsigned_char_data.a[3]]++;
		wide_data[6].data = d[6].sf;
		hist_private[504][wide_data[6].unsigned_char_data.a[0]]++;
		hist_private[505][wide_data[6].unsigned_char_data.a[1]]++;
		hist_private[506][wide_data[6].unsigned_char_data.a[2]]++;
		hist_private[507][wide_data[6].unsigned_char_data.a[3]]++;
		wide_data[7].data = d[7].sf;
		hist_private[508][wide_data[7].unsigned_char_data.a[0]]++;
		hist_private[509][wide_data[7].unsigned_char_data.a[1]]++;
		hist_private[510][wide_data[7].unsigned_char_data.a[2]]++;
		hist_private[511][wide_data[7].unsigned_char_data.a[3]]++;


	}

	barrier(CLK_LOCAL_MEM_FENCE);
	int h;
	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < bin_size;i+=1) {
		int h = 0;
		for (int j = 0; j < NO_OF_PORTS*4*4*VECTOR_TYPE_LENGTH; j+=1) {
			h += hist_private[j][i];

		}
		Hist[i] = h;

	}
}



