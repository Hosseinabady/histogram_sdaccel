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
