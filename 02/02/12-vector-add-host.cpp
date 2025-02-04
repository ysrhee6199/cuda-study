#include "./common.cpp"
#include <stdlib.h>

const unsigned SIZE = 256* 1024 * 1024;

void setRandomData(float* dst, int size)
{
    while(size--)
    {
        *dst++ = (rand()%1000)/1000.0F;
    }
}

int main(void)
{
    float* vecA = new float[SIZE];
    float* vecB = new float[SIZE];
    float* vecC = new float[SIZE];

    srand(0);
    setNormalizedRandomData(vecA, SIZE);
    setNormalizedRandomData(vecB, SIZE);
    ELAPSED_TIME_BEGIN(0);
    for (register unsigned i = 0; i<SIZE;++i)
    {
        vecC[i] = vecA[i] + vecB[i];
    }
    ELAPSED_TIME_END(0);

    float sumA = getSum(vecA,SIZE);
    float sumB = getSum(vecB,SIZE);
    float sumC = getSum(vecC,SIZE);
    float diff = fabsf(sumC - (sumA+sumB));

    printf("SIZE = %d\n", SIZE);
	printf("sumA = %f\n", sumA);
	printf("sumB = %f\n", sumB);
	printf("sumC = %f\n", sumC);
	printf("diff(sumC, sumA+sumB) =  %f\n", diff);
	printf("diff(sumC, sumA+sumB) / SIZE =  %f\n", diff / SIZE);
	printVec("vecA",vecA,SIZE);
    printVec("vecB",vecB,SIZE);
    printVec("vecC",vecC,SIZE);
    // cleaning
	delete[] vecA;
	delete[] vecB;
	delete[] vecC;

    return 0;
}