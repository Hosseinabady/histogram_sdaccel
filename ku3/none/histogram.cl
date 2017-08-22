#include "histogram.h"


pipe  INPUT_DATA_TYPE pdata __attribute__((xcl_reqd_pipe_depth(PIPE_DEPTH)));




__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
read_data_kernel(__global INPUT_DATA_TYPE* vectorData, int data_length) {


	data_length = DATA_LENGTH;
	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < DATA_LENGTH; i++) {
		write_pipe_block(pdata, &vectorData[i]);
	}

}




__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
compute_data_histogram_kernel(int data_length, int bin_size, __global BIN_DATA_TYPE *hist) {

	data_length = DATA_LENGTH;
	bin_size = BIN_SIZE;

	local BIN_DATA_TYPE  hist_local[BIN_SIZE];


	for (int i = 0; i < BIN_SIZE; i++) {
		hist_local[i] = 0;
	}


	INPUT_DATA_TYPE d_1;
	unsigned int        index_1;
	BIN_DATA_TYPE  hist_1;

	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i+=1) {

		read_pipe_block(pdata, &d_1);

		index_1 = (unsigned int)d_1;

		hist_local[index_1]++;
	}

	async_work_group_copy(hist, hist_local, BIN_SIZE, 0);

}



