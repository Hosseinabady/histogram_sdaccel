#include "histogram.h"

#include <stdio.h>
#include <ap_int.h>
#include <string.h>
#include <hls_stream.h>
#include "histogram.h"




inline void histogram_core(
		ap_uint<512>     *inputImage_1,
		ap_uint<512>     *inputImage_2,
		ap_uint<512>     *inputImage_3,
		ap_uint<512>     *inputImage_4,
		unsigned int               hist_local[4*4*4*16][BIN_LENGTH],
		int               data_length,
		int               bin_length
								   ) {


#pragma HLS DATAFLOW
	hls::stream<ap_uint<512> > input_X_fifo_1;
	hls::stream<ap_uint<512> > input_X_fifo_2;
	hls::stream<ap_uint<512> > input_X_fifo_3;
	hls::stream<ap_uint<512> > input_X_fifo_4;


	hls::stream<DATA_TYPE> bin_value_fifo;
	hls::stream<int> bin_index_fifo;

	//receive data
	for (int i = 0; i < data_length/(4*16); i++) {
#pragma HLS PIPELINE
		input_X_fifo_1 << inputImage_1[i];
		input_X_fifo_2 << inputImage_2[i];
		input_X_fifo_3 << inputImage_3[i];
		input_X_fifo_4 << inputImage_4[i];

	}

	//computation
	for (int i = 0; i < data_length/(4*4*16); i++) {
#pragma HLS PIPELINE

		ap_uint<512>  value512_1_1;
		ap_uint<512>  value512_2_1;
		ap_uint<512>  value512_3_1;
		ap_uint<512>  value512_4_1;

		ap_uint<512>  value512_1_2;
		ap_uint<512>  value512_2_2;
		ap_uint<512>  value512_3_2;
		ap_uint<512>  value512_4_2;

		ap_uint<512>  value512_1_3;
		ap_uint<512>  value512_2_3;
		ap_uint<512>  value512_3_3;
		ap_uint<512>  value512_4_3;


		ap_uint<512>  value512_1_4;
		ap_uint<512>  value512_2_4;
		ap_uint<512>  value512_3_4;
		ap_uint<512>  value512_4_4;



		DATA_TYPE  value_1[4*4*16];
#pragma HLS ARRAY_PARTITION variable=value_1 complete dim=1
		DATA_TYPE  value_2[4*4*16];
#pragma HLS ARRAY_PARTITION variable=value_2 complete dim=1
		DATA_TYPE  value_3[4*4*16];
#pragma HLS ARRAY_PARTITION variable=value_3 complete dim=1
		DATA_TYPE  value_4[4*4*16];
#pragma HLS ARRAY_PARTITION variable=value_4 complete dim=1



		int index_1[4*4*16];
#pragma HLS ARRAY_PARTITION variable=index_1 complete dim=1
		int index_2[4*4*16];
#pragma HLS ARRAY_PARTITION variable=index_2 complete dim=1
		int index_3[4*4*16];
#pragma HLS ARRAY_PARTITION variable=index_3 complete dim=1
		int index_4[4*4*16];
#pragma HLS ARRAY_PARTITION variable=index_4 complete dim=1






		value512_1_1 = input_X_fifo_1.read();
		value512_2_1 = input_X_fifo_1.read();
		value512_3_1 = input_X_fifo_1.read();
		value512_4_1 = input_X_fifo_1.read();

		value512_1_2 = input_X_fifo_2.read();
		value512_2_2 = input_X_fifo_2.read();
		value512_3_2 = input_X_fifo_2.read();
		value512_4_2 = input_X_fifo_2.read();

		value512_1_3 = input_X_fifo_3.read();
		value512_2_3 = input_X_fifo_3.read();
		value512_3_3 = input_X_fifo_3.read();
		value512_4_3 = input_X_fifo_3.read();

		value512_1_4 = input_X_fifo_4.read();
		value512_2_4 = input_X_fifo_4.read();
		value512_3_4 = input_X_fifo_4.read();
		value512_4_4 = input_X_fifo_4.read();


		for (int i = 0; i < 4*16; i++) {
			value_1[4*i+0] = value512_1_1((i+1)*8-1,(i)*8);
			index_1[4*i+0] = value_1[4*i+0];
			value_2[4*i+0] = value512_2_1((i+1)*8-1,(i)*8);
			index_2[4*i+0] = value_2[4*i+0];
			value_3[4*i+0] = value512_3_1((i+1)*8-1,(i)*8);
			index_3[4*i+0] = value_3[4*i+0];
			value_4[4*i+0] = value512_4_1((i+1)*8-1,(i)*8);
			index_4[4*i+0] = value_4[4*i+0];

			value_1[4*i+1] = value512_1_2((i+1)*8-1,(i)*8);
			index_1[4*i+1] = value_1[4*i+1];
			value_2[4*i+1] = value512_2_2((i+1)*8-1,(i)*8);
			index_2[4*i+1] = value_2[4*i+1];
			value_3[4*i+1] = value512_3_2((i+1)*8-1,(i)*8);
			index_3[4*i+1] = value_3[4*i+1];
			value_4[4*i+1] = value512_4_2((i+1)*8-1,(i)*8);
			index_4[4*i+1] = value_4[4*i+1];


			value_1[4*i+2] = value512_1_3((i+1)*8-1,(i)*8);
			index_1[4*i+2] = value_1[4*i+2];
			value_2[4*i+2] = value512_2_3((i+1)*8-1,(i)*8);
			index_2[4*i+2] = value_2[4*i+2];
			value_3[4*i+2] = value512_3_3((i+1)*8-1,(i)*8);
			index_3[4*i+2] = value_3[4*i+2];
			value_4[4*i+2] = value512_4_3((i+1)*8-1,(i)*8);
			index_4[4*i+2] = value_4[4*i+2];


			value_1[4*i+3] = value512_1_4((i+1)*8-1,(i)*8);
			index_1[4*i+3] = value_1[4*i+3];
			value_2[4*i+3] = value512_2_4((i+1)*8-1,(i)*8);
			index_2[4*i+3] = value_2[4*i+3];
			value_3[4*i+3] = value512_3_4((i+1)*8-1,(i)*8);
			index_3[4*i+3] = value_3[4*i+3];
			value_4[4*i+3] = value512_4_4((i+1)*8-1,(i)*8);
			index_4[4*i+3] = value_4[4*i+3];
		}




		for (int i = 0; i < 4*4*16; i++) {
			hist_local[i*4+0][index_1[i]] = hist_local[i*4+0][index_1[i]] + 1;
			hist_local[i*4+1][index_2[i]] = hist_local[i*4+1][index_2[i]] + 1;
			hist_local[i*4+2][index_3[i]] = hist_local[i*4+2][index_3[i]] + 1;
			hist_local[i*4+3][index_4[i]] = hist_local[i*4+3][index_4[i]] + 1;
		}


	}

}


extern "C" {
void histogram_kernel(
				ap_uint<512> 		   *inputImage_1,
				ap_uint<512> 		   *inputImage_2,
				ap_uint<512> 		   *inputImage_3,
				ap_uint<512> 		   *inputImage_4,
		        int                    *hitogram,
				int                     data_length,
				int                     bin_length
				) {





#pragma HLS INTERFACE m_axi  offset=slave    port=inputImage_1    bundle=gmem_0
#pragma HLS INTERFACE m_axi  offset=slave    port=inputImage_2    bundle=gmem_1
#pragma HLS INTERFACE m_axi  offset=slave    port=inputImage_3    bundle=gmem_2
#pragma HLS INTERFACE m_axi  offset=slave    port=inputImage_4    bundle=gmem_3
#pragma HLS INTERFACE m_axi  offset=slave    port=hitogram        bundle=gmem_4

#pragma HLS INTERFACE s_axilite port=inputImage_1 bundle=control
#pragma HLS INTERFACE s_axilite port=inputImage_2 bundle=control
#pragma HLS INTERFACE s_axilite port=inputImage_3 bundle=control
#pragma HLS INTERFACE s_axilite port=inputImage_4 bundle=control
#pragma HLS INTERFACE s_axilite port=hitogram     bundle=control

#pragma HLS INTERFACE s_axilite port=data_length bundle=control
#pragma HLS INTERFACE s_axilite port=bin_length  bundle=control

#pragma HLS INTERFACE s_axilite port=return       bundle=control

	unsigned int    hist_local[4*4*4*16][BIN_LENGTH];
#pragma HLS ARRAY_PARTITION variable=hist_local complete dim=1

//	data_length = DATA_LENGTH;
	bin_length = BIN_LENGTH;
	for (int i = 0; i < bin_length; i++) {
#pragma HLS PIPELINE
		for (int j = 0; j < 4*4*4*16 ; j++) {
			hist_local[j][i] = 0;

		}
	}

	unsigned int h = 0;

	histogram_core(inputImage_1, inputImage_2, inputImage_3, inputImage_4, hist_local, data_length, bin_length);


	computaion_loop_4 : for (int i = 0; i < bin_length; i++) {
#pragma HLS PIPELINE II=1
		h = 0;
		for (int j = 0; j < 4*4*4*16 ; j++) {
			h += hist_local[j][i];
		}

		hitogram[i] = h;
	}


}
}
