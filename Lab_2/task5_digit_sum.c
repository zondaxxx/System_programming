/* Лабораторная работа №2. Задание 5. Вариант 16.
   Сумма цифр числа N на языке C (обычная версия с использованием stdio). */
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
