// nvcc hello-pararllel.cu -gencode arch=compute_86,code=sm_86 -o a.out
#include <stdio.h>

__global__ void hello(void)
{
    printf("hello CUDA%d!\n",threadIdx.x);
}

int main(void)
{
    hello<<<1,8>>>();
    cudaDeviceSynchronize();
    fflush(stdout);
    return 0;   
}