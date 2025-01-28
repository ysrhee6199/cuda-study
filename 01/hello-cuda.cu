#include <stdio.h>

__global__ void hello(void)
{
    printf("hello CUDA%d!\n",threadIdx.x);
}

int main(void)
{
    hello<<<1,81>>>();
    fflush(stdout);
    return 0;   
}