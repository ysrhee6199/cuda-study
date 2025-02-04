#include "./common.cpp"
const unsigned SIZE = 1024 * 1024; // 1M elements

__global__ void singleKernelVecAdd(float* c, const float* a, const float* b, unsigned n)
{
    unsigned i = threadIdx.x;
    if( i < n) // 배열 크기 보다 쓰레드의 크기가 더 클 수 있음
    {
        c[i] = a[i] + b[i];
    }
}

int main(void){
    
    float* vecA = new float[SIZE];
    float* vecB = new float[SIZE];
    float* vecC = new float[SIZE];

    srand(0);
    setNormalizedRandomData(vecA, SIZE);
    setNormalizedRandomData(vecB, SIZE);

    float* dev_vecA = nullptr;
	float* dev_vecB = nullptr;
	float* dev_vecC = nullptr;

    cudaMalloc((void**)&dev_vecA, SIZE*sizeof(float));
    cudaMalloc((void**)&dev_vecB,SIZE*sizeof(float));
    cudaMalloc((void**)&dev_vecC, SIZE * sizeof(float));
    ELAPSED_TIME_BEGIN(1);
    cudaMemcpy(dev_vecA,vecA,SIZE*sizeof(float),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_vecB,vecB,SIZE*sizeof(float),cudaMemcpyHostToDevice);
    
    ELAPSED_TIME_BEGIN(0);
    singleKernelVecAdd<<<1,SIZE>>>(dev_vecC,dev_vecB,dev_vecA,SIZE);
    cudaDeviceSynchronize();
    CUDA_CHECK_ERROR();
    ELAPSED_TIME_END(0);

    cudaMemcpy(vecC,dev_vecC,SIZE*sizeof(float),cudaMemcpyDeviceToHost);
    ELAPSED_TIME_END(1);
    cudaFree(dev_vecA);
    cudaFree(dev_vecB);
    cudaFree(dev_vecC);

	CUDA_CHECK_ERROR();
	// check the result
	float sumA = getSum( vecA, SIZE );
	float sumB = getSum( vecB, SIZE );
	float sumC = getSum( vecC, SIZE );
	float diff = fabsf( sumC - (sumA + sumB) );
	printf("SIZE = %d\n", SIZE);
	printf("sumA = %f\n", sumA);
	printf("sumB = %f\n", sumB);
	printf("sumC = %f\n", sumC);
	printf("diff(sumC, sumA+sumB) =  %f\n", diff);
	printf("diff(sumC, sumA+sumB) / SIZE =  %f\n", diff / SIZE);
	printVec( "vecA", vecA, SIZE );
	printVec( "vecB", vecB, SIZE );
	printVec( "vecC", vecC, SIZE );
	// cleaning
	delete[] vecA;
	delete[] vecB;
	delete[] vecC;
	// done


    return 0;
}