#include <stdio.h>

int main(void)
{
    unsigned long n = 2710058798UL;
    unsigned int sum = 0;
    while (n) {
        sum += n % 10;
        n /= 10;
    }
    printf("Sum of digits of 2710058798 = %u\n", sum);
    return 0;
}
