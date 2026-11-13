#include "input.h"

int main(void) {
    long long n;
    long long count = 0;
    if (!read_number(1000000, &n)) return invalid_input();
    for (long long i = 5; i <= n; i += 5) {
        if (i % 3 != 0 && i % 7 != 0) count++;
    }
    printf("%lld\n", count);
    return 0;
}
