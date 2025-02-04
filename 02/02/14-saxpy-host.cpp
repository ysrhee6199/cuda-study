#include "./common.cpp"

unsigned vecSize = 256 * 1024 * 1024;
float saxpy_a = 1.234f;

int main()
{
    float* vecX = new float[vecSize];
    float* vecY = new float[vecSize];
    float* vecZ = new float[vecSize];
	// set random data
	srand( 0 );
	setNormalizedRandomData( vecX, vecSize );
	setNormalizedRandomData( vecY, vecSize );

    
    ELAPSED_TIME_BEGIN(0);

    for(register unsigned i = 0;i <vecSize; i++)
    {
        vecZ[i] = saxpy_a * vecX[i] + vecY[i];
    }
    ELAPSED_TIME_END(0);

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