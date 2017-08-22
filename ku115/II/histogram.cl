#include "histogram.h"


pipe  INPUT_DATA_TYPE pdata __attribute__((xcl_reqd_pipe_depth(PIPE_DEPTH)));




__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
read_data_kernel(__global INPUT_DATA_TYPE* vectorData, int data_length) {

	data_length = DATA_LENGTH;

	int local_index  = get_local_id(0);
	int global_index;


	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i++) {
		global_index = local_index*(data_length) + i;
		INPUT_DATA_TYPE d = vectorData[global_index];
		write_pipe_block(pdata, &d);
	}

}




__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
compute_data_histogram_kernel(int data_length, int bin_size, __global int *hist) {

	data_length = DATA_LENGTH;
	bin_size = BIN_SIZE;
	int local_index  = get_local_id(0);


	BIN_DATA_TYPE  hist_private_1[BIN_SIZE];
	BIN_DATA_TYPE  hist_private_2[BIN_SIZE];
	BIN_DATA_TYPE  hist_private_3[BIN_SIZE];
	BIN_DATA_TYPE  hist_private_4[BIN_SIZE];


	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < bin_size; i++) {
		hist_private_1[i] = 0;
		hist_private_2[i] = 0;
		hist_private_3[i] = 0;
		hist_private_4[i] = 0;
	}



	INPUT_DATA_TYPE d_1;
	INPUT_DATA_TYPE d_2;
	INPUT_DATA_TYPE d_3;
	INPUT_DATA_TYPE d_4;

	int       index_1;
	int       index_2;
	int       index_3;
	int       index_4;


	int hist_1;
	int hist_2;
	int hist_3;
	int hist_4;



	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < data_length; i+=4) {

		read_pipe_block(pdata, &d_1);
		read_pipe_block(pdata, &d_2);
		read_pipe_block(pdata, &d_3);
		read_pipe_block(pdata, &d_4);

		index_1 = (int)d_1;
		index_2 = (int)d_2;
		index_3 = (int)d_3;
		index_4 = (int)d_4;

		hist_private_1[index_1]++;
		hist_private_2[index_2]++;
		hist_private_3[index_3]++;
		hist_private_4[index_4]++;



	}

	BIN_DATA_TYPE h;
	__attribute__((xcl_pipeline_loop))
	for (int i = 0; i < bin_size;i++) {
		h = hist_private_1[i]+hist_private_2[i] + hist_private_3[i]+hist_private_4[i];
		hist[i] = h;
	}
}




