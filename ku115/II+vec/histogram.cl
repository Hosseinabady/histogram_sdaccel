#include "histogram.h"

#define VECTOR_TYPE_LENGTH 16
#define VECTOR_DATA_TYPE INPUT_DATA_TYPE16

pipe  VECTOR_DATA_TYPE pdata __attribute__((xcl_reqd_pipe_depth(PIPE_DEPTH)));



__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
read_data_kernel(__global VECTOR_DATA_TYPE* vectorData, int data_length) {

	  data_length = DATA_LENGTH/VECTOR_TYPE_LENGTH;


	int global_index;


	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i+=1) {
		global_index =   i;
		VECTOR_DATA_TYPE d = vectorData[global_index];
		write_pipe_block(pdata, &d);
	}

}


  __kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
compute_data_histogram_kernel(int data_length, int bin_size, __global BIN_DATA_TYPE *Hist) {

	  bin_size    = BIN_SIZE;
	  data_length = DATA_LENGTH;

	  local BIN_DATA_TYPE  hist_local[BIN_SIZE];
	  local BIN_DATA_TYPE  hist_private[4*4*VECTOR_TYPE_LENGTH][BIN_SIZE] __attribute__((xcl_array_partition(complete, 1)));


	  __attribute__((xcl_pipeline_loop))
	  for (int i = 0; i < bin_size; i++) {
		  hist_local[i] = 0;
		  for (int j = 0; j < 4*4*VECTOR_TYPE_LENGTH; j++) {
			  hist_private[j][i] = 0;
		  }
	  }
	  VECTOR_DATA_TYPE d[4]  __attribute__((xcl_array_partition(complete, 1)));

	  WIDE_DATA_TYPE wide_data[4]  __attribute__((xcl_array_partition(complete, 1)));



	  __attribute__((xcl_pipeline_loop))
	  for (int i = 0; i < data_length; i += 4*VECTOR_TYPE_LENGTH) {


		read_pipe_block(pdata, &d[0]);
		read_pipe_block(pdata, &d[1]);
		read_pipe_block(pdata, &d[2]);
		read_pipe_block(pdata, &d[3]);


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
		wide_data[0].data = d[0].s1;
		hist_private[16][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[17][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[18][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[19][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s1;
		hist_private[20][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[21][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[22][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[23][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s1;
		hist_private[24][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[25][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[26][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[27][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s1;
		hist_private[28][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[29][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[30][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[31][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s2;
		hist_private[32][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[33][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[34][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[35][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s2;
		hist_private[36][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[37][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[38][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[39][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s2;
		hist_private[40][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[41][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[42][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[43][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s2;
		hist_private[44][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[45][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[46][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[47][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s3;
		hist_private[48][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[49][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[50][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[51][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s3;
		hist_private[52][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[53][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[54][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[55][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s3;
		hist_private[56][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[57][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[58][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[59][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s3;
		hist_private[60][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[61][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[62][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[63][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s4;
		hist_private[64][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[65][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[66][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[67][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s4;
		hist_private[68][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[69][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[70][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[71][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s4;
		hist_private[72][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[73][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[74][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[75][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s4;
		hist_private[76][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[77][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[78][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[79][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s5;
		hist_private[80][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[81][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[82][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[83][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s5;
		hist_private[84][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[85][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[86][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[87][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s5;
		hist_private[88][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[89][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[90][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[91][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s5;
		hist_private[92][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[93][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[94][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[95][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s6;
		hist_private[96][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[97][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[98][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[99][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s6;
		hist_private[100][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[101][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[102][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[103][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s6;
		hist_private[104][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[105][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[106][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[107][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s6;
		hist_private[108][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[109][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[110][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[111][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s7;
		hist_private[112][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[113][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[114][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[115][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s7;
		hist_private[116][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[117][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[118][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[119][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s7;
		hist_private[120][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[121][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[122][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[123][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s7;
		hist_private[124][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[125][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[126][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[127][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s8;
		hist_private[128][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[129][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[130][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[131][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s8;
		hist_private[132][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[133][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[134][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[135][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s8;
		hist_private[136][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[137][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[138][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[139][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s8;
		hist_private[140][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[141][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[142][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[143][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].s9;
		hist_private[144][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[145][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[146][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[147][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].s9;
		hist_private[148][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[149][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[150][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[151][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].s9;
		hist_private[152][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[153][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[154][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[155][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].s9;
		hist_private[156][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[157][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[158][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[159][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sa;
		hist_private[160][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[161][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[162][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[163][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sa;
		hist_private[164][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[165][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[166][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[167][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sa;
		hist_private[168][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[169][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[170][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[171][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sa;
		hist_private[172][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[173][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[174][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[175][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sb;
		hist_private[176][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[177][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[178][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[179][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sb;
		hist_private[180][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[181][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[182][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[183][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sb;
		hist_private[184][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[185][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[186][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[187][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sb;
		hist_private[188][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[189][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[190][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[191][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sc;
		hist_private[192][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[193][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[194][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[195][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sc;
		hist_private[196][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[197][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[198][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[199][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sc;
		hist_private[200][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[201][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[202][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[203][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sc;
		hist_private[204][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[205][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[206][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[207][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sd;
		hist_private[208][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[209][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[210][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[211][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sd;
		hist_private[212][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[213][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[214][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[215][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sd;
		hist_private[216][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[217][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[218][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[219][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sd;
		hist_private[220][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[221][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[222][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[223][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].se;
		hist_private[224][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[225][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[226][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[227][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].se;
		hist_private[228][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[229][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[230][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[231][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].se;
		hist_private[232][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[233][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[234][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[235][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].se;
		hist_private[236][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[237][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[238][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[239][wide_data[3].unsigned_char_data.a[3]]++;
		wide_data[0].data = d[0].sf;
		hist_private[240][wide_data[0].unsigned_char_data.a[0]]++;
		hist_private[241][wide_data[0].unsigned_char_data.a[1]]++;
		hist_private[242][wide_data[0].unsigned_char_data.a[2]]++;
		hist_private[243][wide_data[0].unsigned_char_data.a[3]]++;
		wide_data[1].data = d[1].sf;
		hist_private[244][wide_data[1].unsigned_char_data.a[0]]++;
		hist_private[245][wide_data[1].unsigned_char_data.a[1]]++;
		hist_private[246][wide_data[1].unsigned_char_data.a[2]]++;
		hist_private[247][wide_data[1].unsigned_char_data.a[3]]++;
		wide_data[2].data = d[2].sf;
		hist_private[248][wide_data[2].unsigned_char_data.a[0]]++;
		hist_private[249][wide_data[2].unsigned_char_data.a[1]]++;
		hist_private[250][wide_data[2].unsigned_char_data.a[2]]++;
		hist_private[251][wide_data[2].unsigned_char_data.a[3]]++;
		wide_data[3].data = d[3].sf;
		hist_private[252][wide_data[3].unsigned_char_data.a[0]]++;
		hist_private[253][wide_data[3].unsigned_char_data.a[1]]++;
		hist_private[254][wide_data[3].unsigned_char_data.a[2]]++;
		hist_private[255][wide_data[3].unsigned_char_data.a[3]]++;

	}



	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < bin_size;i+=1) {

		for (int j = 0; j < 4*4*VECTOR_TYPE_LENGTH; j+=1) {
			hist_local[i] += hist_private[j][i];
		}
	}

	async_work_group_copy(Hist, hist_local, bin_size, 0);



}



