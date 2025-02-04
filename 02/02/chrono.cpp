#include "./common.cpp"

void bigjob(void)
{
    int count  = 0;
    for(int i = 0; i<10000; i++)
    {
        for( int j = 0; j<10000; j++)
        {
            count++;
        }
    }
    printf("we got %d counts \n",count);
}

int main()
{
    ELAPSED_TIME_BEGIN(0);

    //work
    bigjob();
    ELAPSED_TIME_END(0);

    return 0;
}