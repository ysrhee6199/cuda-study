#include "./common.cpp"
//CUDA_CHECK_ERROR();
unsigned vecSize = 256 * 1024 * 1024;
float saxpy_a = 1.234f;

__global__ void kernelSAXPY(float* z, const float a, const float* x, const float* y, unsigned n)
{
    unsigned i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < n)
    {
        //z[i] = a * x[i] + y[i];
        z[i] = fmaf(a,x[i],y[i]);
    }
}

int main()
{
    float* vecX = new float[vecSize];
    float* vecY = new float[vecSize];
    float* vecZ = new float[vecSize];
	// set random data
	srand( 0 );
	setNormalizedRandomData( vecX, vecSize );
	setNormalizedRandomData( vecY, vecSize );

    float* dev_vecX = nullptr;
    float* dev_vecY = nullptr;
    float* dev_vecZ = nullptr;

    cudaMalloc((void**)&dev_vecX, vecSize * sizeof(float));
    cudaMalloc((void**)&dev_vecY, vecSize * sizeof(float));
    cudaMalloc((void**)&dev_vecZ, vecSize * sizeof(float));
    CUDA_CHECK_ERROR();

    ELAPSED_TIME_BEGIN(1);
    cudaMemcpy(dev_vecX,vecX,vecSize*sizeof(float),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_vecY,vecY,vecSize*sizeof(float),cudaMemcpyHostToDevice);
    CUDA_CHECK_ERROR();

    // CUDA kernel launch
	dim3 dimBlock( 1024, 1, 1 );
	dim3 dimGrid( (vecSize + (dimBlock.x - 1)) / dimBlock.x, 1, 1 );

    ELAPSED_TIME_BEGIN(0);
    kernelSAXPY<<<dimGrid,dimBlock>>>(dev_vecZ,saxpy_a,dev_vecX,dev_vecY,vecSize);
    cudaDeviceSynchronize();
    ELAPSED_TIME_END(0);
    CUDA_CHECK_ERROR();

    cudaMemcpy(vecZ,dev_vecZ,vecSize*sizeof(float),cudaMemcpyDeviceToHost);
    CUDA_CHECK_ERROR();
    ELAPSED_TIME_END(1);

    
    cudaFree(dev_vecX);
    cudaFree(dev_vecY);
    cudaFree(dev_vecZ);
    CUDA_CHECK_ERROR();

// check the result
	float sumX = getSum( vecX, vecSize );
	float sumY = getSum( vecY, vecSize );
	float sumZ = getSum( vecZ, vecSize );
	float diff = fabsf( sumZ - (saxpy_a * sumX + sumY) );
	printf("SIZE = %d\n", vecSize);
	printf("a    = %f\n", saxpy_a);
	printf("sumX = %f\n", sumX);
	printf("sumY = %f\n", sumY);
	printf("sumZ = %f\n", sumZ);
	printf("diff(sumZ, a*sumX+sumY) =  %f\n", diff);
	printf("diff(sumZ, a*sumX+sumY)/SIZE =  %f\n", diff / vecSize);
	printVec( "vecX", vecX, vecSize );
	printVec( "vecY", vecY, vecSize );
	printVec( "vecZ", vecZ, vecSize );
	// cleaning
	delete[] vecX;
	delete[] vecY;
	delete[] vecZ;
	// done
	return 0;

    
}