#include "histogram.h"


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <CL/opencl.h>


#define GLOBAL_SIZE(x)	1;
double getTimestamp();
int load_file_to_memory(const char *filename, char **result);
void histogram_golden(DATA_TYPE *Data, int *Histogram, int data_size, int bin_size);


double start_app_time;
double end_app_time;
double app_total_time;



int main(int argc, char** argv) {
	int data_size = DATA_LENGTH;
	int bin_size = BIN_LENGTH;

	printf("From main: Hello Histogram Version:01 \n");
	printf("From main: =====================\n");





	printf("check point 1\n");
	DATA_TYPE *h_Data;
	int *h_Histogram;
	int *h_Histogram_golden;




	int err;
    size_t global[1];                   // global domain size
    size_t local[1];                    // local domain size

    cl_platform_id platform_id;         // platform id
    cl_device_id device_id;             // compute device id
    cl_context context;                 // compute context
    cl_command_queue commands;          // compute command queue
    cl_program program;      // compute programs

    cl_kernel histogram_kernel;                   // compute mean kernel


    cl_mem d_Data_1;                         // device memory used for data
    cl_mem d_Data_2;                         // device memory used for data
    cl_mem d_Data_3;                         // device memory used for data
    cl_mem d_Data_4;                         // device memory used for data
    cl_mem d_Histogram;                         // device memory used for mean


    cl_mem_ext_ptr_t d_Data_ext_1;
    cl_mem_ext_ptr_t d_Data_ext_2;
    cl_mem_ext_ptr_t d_Data_ext_3;
    cl_mem_ext_ptr_t d_Data_ext_4;

//    cl_mem_ext_ptr_t d_Histogram_ext;

    cl_ulong time_start, time_end;
    double total_time;

    printf("check point 2\n");
    h_Data = (DATA_TYPE*)malloc(sizeof(DATA_TYPE)*data_size);
    h_Histogram = (int*)malloc(sizeof(int)*bin_size);
    h_Histogram_golden = (int*)malloc(sizeof(int)*bin_size);

    printf("check point 3\n");

    //initialization

    for(int i = 0; i < data_size; i++) {

    	DATA_TYPE t;

    	t = rand()%bin_size;
    	h_Data[i] = t;

    }

    for(int i = 0; i < bin_size; i++) {
   		h_Histogram[i] = 0;
   		h_Histogram_golden[i] = 0;
    }




    d_Data_ext_1.flags = XCL_MEM_DDR_BANK0;
    d_Data_ext_1.obj   = h_Data+0*data_size/4;
    d_Data_ext_1.param = 0;

    d_Data_ext_2.flags = XCL_MEM_DDR_BANK1;
    d_Data_ext_2.obj   = h_Data+1*data_size/4;
    d_Data_ext_2.param = 0;

    d_Data_ext_3.flags = XCL_MEM_DDR_BANK2;
    d_Data_ext_3.obj   = h_Data+2*data_size/4;
    d_Data_ext_3.param = 0;

    d_Data_ext_4.flags = XCL_MEM_DDR_BANK3;
    d_Data_ext_4.obj   = h_Data+3*data_size/4;
    d_Data_ext_4.param = 0;



//    d_Histogram_ext.flags = XCL_MEM_DDR_BANK0;
//    d_Histogram_ext.obj   = h_Histogram;
//    d_Histogram_ext.param = 0;

	 // Connect to first platform
	 //
	 err = clGetPlatformIDs(1,&platform_id,NULL);
	 if (err != CL_SUCCESS) {
		 printf("Error: Failed to find an OpenCL platform!\n");
	     printf("Test failed\n");
	     return EXIT_FAILURE;
	 }
		{
			int num_platforms = 1;
			char buffer[10240];
			printf(" %d platform(s) found\n", num_platforms);
			printf(" =====================\n");
			printf("\n");

			for (int i = 0; i <num_platforms; i++) {
				printf("platform number %d \n", i);
				printf("------------------------\n");
				clGetPlatformInfo(platform_id, CL_PLATFORM_PROFILE, 10240, buffer, NULL);
				printf("  CL_PLATFORM_PROFILE = %s\n", buffer);

				clGetPlatformInfo(platform_id, CL_PLATFORM_VERSION, 10240, buffer, NULL);
				printf("  CL_PLATFORM_VERSION = %s\n", buffer);

				clGetPlatformInfo(platform_id, CL_PLATFORM_NAME, 10240, buffer, NULL);
				printf("  CL_PLATFORM_NAME = %s\n", buffer);

				clGetPlatformInfo(platform_id, CL_PLATFORM_VENDOR, 10240, buffer, NULL);
				printf("  CL_PLATFORM_VENDOR = %s\n", buffer);

				clGetPlatformInfo(platform_id, CL_PLATFORM_EXTENSIONS, 10240, buffer, NULL);
				printf("  CL_PLATFORM_EXTENSIONS = %s\n", buffer);



			}
			printf("\n");
			printf("\n");
			printf("\n");
		}


	  // Connect to a compute device
	    //
	err = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_ACCELERATOR,
	                         1, &device_id, NULL);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to create a device group!\n");
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


	{
		char     buffer[10240];
		cl_ulong buf_ulong;
		cl_uint  buf_uint;
		size_t   buf_size_arr[3];
		size_t   buf_size;

		printf(" 1 device found\n");
		printf(" =====================\n");
		printf("\n");
		printf("------------------------\n");
		clGetDeviceInfo(device_id, CL_DEVICE_NAME, 10240, buffer, NULL);
		printf("  CL_DEVICE_NAME = %s\n", buffer);

		clGetDeviceInfo(device_id, CL_DEVICE_VENDOR, 10240, buffer, NULL);
		printf("  CL_DEVICE_VENDOR = %s\n", buffer);

		clGetDeviceInfo(device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(buf_uint), &buf_uint, NULL);
		printf("  CL_DEVICE_MAX_COMPUTE_UNITS = %u\n",  buf_uint);

		clGetDeviceInfo(device_id, CL_DEVICE_MAX_CLOCK_FREQUENCY, sizeof(buf_uint), &buf_uint, NULL);
		printf("  CL_DEVICE_MAX_CLOCK_FREQUENCY = %u\n",  buf_uint);

		clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_SIZE, sizeof(buf_ulong), &buf_ulong, NULL);
		printf("  CL_DEVICE_GLOBAL_MEM_SIZE = %lu\n",  buf_ulong);

		clGetDeviceInfo(device_id, CL_DEVICE_LOCAL_MEM_SIZE, sizeof(buf_ulong), &buf_ulong, NULL);
		printf("  CL_DEVICE_LOCAL_MEM_SIZE = %lu\n",  buf_ulong);

		clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_SIZES , sizeof(buf_size_arr), buf_size_arr, NULL);
		printf("  CL_DEVICE_MAX_WORK_ITEM_SIZES = %lu/%lu/%lu \n", buf_size_arr[0], buf_size_arr[1], buf_size_arr[2]);

		clGetDeviceInfo(device_id,  CL_DEVICE_MAX_WORK_GROUP_SIZE , sizeof(buf_size), &buf_size, NULL);
		printf("  CL_DEVICE_MAX_WORK_GROUP_SIZE = %lu \n", buf_size);

		printf("\n");
		printf("\n");
		printf("\n");
	}


	printf("check point 4\n");
	// Create a compute context
	//
	context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
	if (!context) {
		printf("Error: Failed to create a compute context!\n");
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}
	printf("check point 5\n");
	// Create a command commands
	//
	commands = clCreateCommandQueue(context, device_id, CL_QUEUE_PROFILING_ENABLE|CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err);
	if (!commands) {
		printf("Error: Failed to create a command commands!\n");
	    printf("Error: code %i\n",err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	int status;

	printf("check point 6\n");
	// Load binary from disk

	unsigned char* kernelbinary;
	char *xclbin = argv[1];

	printf("xclbin = %s\n", xclbin);
	//------------------------------------------------------------------------------
	// xclbin mean
	//------------------------------------------------------------------------------
	printf("INFO: loading xclbin_mean %s\n", xclbin);
	int n_i = load_file_to_memory(xclbin, (char **) &kernelbinary);
	if (n_i < 0) {
		printf("failed to load kernel from xclbin_mean: %s\n", xclbin);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}
	printf("check point 7\n");
	size_t n0 = n_i;

	// Create the compute program from offline
	program = clCreateProgramWithBinary(context, 1, &device_id, &n0,
	                                        (const unsigned char **) &kernelbinary, &status, &err);

	if ((!program) || (err!=CL_SUCCESS)) {
		printf("Error: Failed to create compute program0 from binary %d!\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}
	printf("check point 8\n");
	// Build the program executable
	//
	err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	if (err != CL_SUCCESS) {
		size_t len;
	    char buffer[2048];

	    printf("Error: Failed to build program executable!\n");
	    clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
	    printf("%s\n", buffer);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	// Create the compute kernel in the program we wish to run
	//
	histogram_kernel = clCreateKernel(program, "histogram_kernel", &err);
	if (!histogram_kernel || err != CL_SUCCESS) {
		printf("Error: Failed to create histogram_kernel!\n");
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


    //------------------------------------------------------------------------------




	printf("check point 9\n");
    // Create the input and output arrays in device memory for our calculation
	//
//	d_Data = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX | CL_MEM_COPY_HOST_PTR,  sizeof(DATA_TYPE) * data_size, &d_Data_ext, NULL);


	d_Data_1 = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX ,  sizeof(DATA_TYPE) * data_size/4, &d_Data_ext_1, NULL);
	d_Data_2 = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX ,  sizeof(DATA_TYPE) * data_size/4, &d_Data_ext_2, NULL);
	d_Data_3 = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX ,  sizeof(DATA_TYPE) * data_size/4, &d_Data_ext_3, NULL);
	d_Data_4 = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX ,  sizeof(DATA_TYPE) * data_size/4, &d_Data_ext_4, NULL);


	d_Histogram = clCreateBuffer(context,  CL_MEM_WRITE_ONLY , sizeof(int) * bin_size, NULL, NULL);

	printf("check point 10\n");

	printf("check point 10\n");
	if (!d_Data_1 || !d_Data_2 || !d_Data_3 || !d_Data_4 || !d_Histogram) {
		printf("Error: Failed to allocate device memory!\n");
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


	err = clEnqueueWriteBuffer( commands, d_Data_1, CL_TRUE, 0, sizeof(DATA_TYPE) * data_size/4, h_Data+0*data_size/4, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	err = clEnqueueWriteBuffer( commands, d_Data_2, CL_TRUE, 0, sizeof(DATA_TYPE) * data_size/4, h_Data+1*data_size/4, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	err = clEnqueueWriteBuffer( commands, d_Data_3, CL_TRUE, 0, sizeof(DATA_TYPE) * data_size/4, h_Data+2*data_size/4, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	err = clEnqueueWriteBuffer( commands, d_Data_4, CL_TRUE, 0, sizeof(DATA_TYPE) * data_size/4, h_Data+3*data_size/4, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


	clFinish(commands);


	cl_event transfer_c_event;
	cl_event histogram_kernel_event;

	// Set the arguments to our mean kernel
	//
	err = 0;
	err  |= clSetKernelArg(histogram_kernel, 0, sizeof(cl_mem), &d_Data_1);
	err  |= clSetKernelArg(histogram_kernel, 1, sizeof(cl_mem), &d_Data_2);
	err  |= clSetKernelArg(histogram_kernel, 2, sizeof(cl_mem), &d_Data_3);
	err  |= clSetKernelArg(histogram_kernel, 3, sizeof(cl_mem), &d_Data_4);
	err  |= clSetKernelArg(histogram_kernel, 4, sizeof(cl_mem), &d_Histogram);
	err  |= clSetKernelArg(histogram_kernel, 5, sizeof(int),    &data_size);
	err  |= clSetKernelArg(histogram_kernel, 6, sizeof(int),    &bin_size);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to set kernel arguments! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


	local[0]  = 1;
	global[0] = 1;


	start_app_time=getTimestamp();
	err = clEnqueueNDRangeKernel(commands, histogram_kernel, 1, NULL,
	                                   (size_t*)&global, (size_t*)&local, 0, NULL, &histogram_kernel_event);
	if (err) {
		printf("Error: Failed to execute kernel! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}



	err = clEnqueueReadBuffer( commands, d_Histogram, CL_TRUE, 0, sizeof(int) * bin_size, h_Histogram, 1, &histogram_kernel_event, &transfer_c_event);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	clFinish(commands);
	end_app_time=getTimestamp();

   	app_total_time = (end_app_time-start_app_time)/1000;
   	printf("First App total execution time  %.6lf ms elapsed\n", app_total_time);
	// Set the arguments to our mean kernel
	//
	err = 0;
	err  |= clSetKernelArg(histogram_kernel, 0, sizeof(cl_mem), &d_Data_1);
	err  |= clSetKernelArg(histogram_kernel, 1, sizeof(cl_mem), &d_Data_2);
	err  |= clSetKernelArg(histogram_kernel, 2, sizeof(cl_mem), &d_Data_3);
	err  |= clSetKernelArg(histogram_kernel, 3, sizeof(cl_mem), &d_Data_4);
	err  |= clSetKernelArg(histogram_kernel, 4, sizeof(cl_mem), &d_Histogram);
	err  |= clSetKernelArg(histogram_kernel, 5, sizeof(int),    &data_size);
	err  |= clSetKernelArg(histogram_kernel, 6, sizeof(int),    &bin_size);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to set kernel arguments! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}


	local[0]  = 1;
	global[0] = 1;


	start_app_time=getTimestamp();
	err = clEnqueueNDRangeKernel(commands, histogram_kernel, 1, NULL,
	                                   (size_t*)&global, (size_t*)&local, 0, NULL, &histogram_kernel_event);
	if (err) {
		printf("Error: Failed to execute kernel! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}



	err = clEnqueueReadBuffer( commands, d_Histogram, CL_TRUE, 0, sizeof(int) * bin_size, h_Histogram, 1, &histogram_kernel_event, &transfer_c_event);
	if (err != CL_SUCCESS) {
		printf("Error: Failed to read output array! %d\n", err);
	    printf("Test failed\n");
	    return EXIT_FAILURE;
	}

	clFinish(commands);
	end_app_time=getTimestamp();



   	printf("check point 13\n");

   	app_total_time = (end_app_time-start_app_time)/1000;
   	printf("Second App total execution time  %.6lf ms elapsed\n", app_total_time);


	clGetEventProfilingInfo(histogram_kernel_event, CL_PROFILING_COMMAND_START,
		sizeof(time_start), &time_start, NULL);
	clGetEventProfilingInfo(histogram_kernel_event, CL_PROFILING_COMMAND_END,
		sizeof(time_end), &time_end, NULL);
	total_time = time_end - time_start;
	printf("\nExecution time for read kernel in milliseconds = %0.3f ms\n", (total_time / 1000000.0));




	clGetEventProfilingInfo(transfer_c_event, CL_PROFILING_COMMAND_START,
		sizeof(time_start), &time_start, NULL);
	clGetEventProfilingInfo(transfer_c_event, CL_PROFILING_COMMAND_END,
		sizeof(time_end), &time_end, NULL);
	total_time = time_end - time_start;
	printf("\nExecution time for transfer c in milliseconds = %0.3f ms\n", (total_time / 1000000.0));



	clReleaseMemObject(d_Data_1);
	clReleaseMemObject(d_Data_2);
	clReleaseMemObject(d_Data_3);
	clReleaseMemObject(d_Data_4);
	clReleaseMemObject(d_Histogram);
	clReleaseEvent(histogram_kernel_event);
	clReleaseEvent(transfer_c_event);
	clReleaseKernel(histogram_kernel);
	clReleaseCommandQueue(commands);
	clReleaseContext(context);




    histogram_golden(h_Data, h_Histogram_golden, data_size, bin_size);

    for (int i = 0; i < bin_size; i++) {
    	int gold=h_Histogram_golden[i];
	   	int hw = h_Histogram[i];
	    DATA_TYPE diff = (gold-hw);
	    if (diff != 0) {
	    	printf("Error at element %d golden= %d, hw=%d\n", i, gold, hw);
	    	break;
	    }
	}


	free(h_Data);
	free(h_Histogram);
	free(h_Histogram_golden);

    printf("From main: Bye Histogram\n");
    printf("From main: ====================\n");
    return 0;
}

void histogram_golden(DATA_TYPE *data, int *Histogram, int data_size, int bin_size) {

	for(int j = 0; j < bin_size; j++) {
			Histogram[j]=0;
	}

	for(int j = 0; j < data_size; j++) {
		u32 d_1 = (data[j] >> 0)  & 0xFFU;
		u32 d_2 = (data[j] >> 8)  & 0xFFU;
		u32 d_3 = (data[j] >> 16) & 0xFFU;
		u32 d_4 = (data[j] >> 24) & 0xFFU;

		Histogram[d_1]++;
		Histogram[d_2]++;
		Histogram[d_3]++;
		Histogram[d_4]++;

	}
}


