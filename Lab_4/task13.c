#include "input.h"

int main(void) {
    long long n;
    if (!read_number(1000000, &n)) return invalid_input();
    for (long long i = 10; i <= n; i++) {
        long long units = i % 10;
        long long tens = i / 10 % 10;
        if (units != 0 && tens != 0 && i % units == 0 && i % tens == 0) {
            printf("%lld\n", i);
        }
    }
    return 0;
}
