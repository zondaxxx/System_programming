#include "input.h"

long long insert_zeros(long long n) {
    long long result = 0;
    long long place = 10;
    do {
        result += n % 10 * place;
        n /= 10;
        if (n != 0) place *= 100;
    } while (n != 0);
    return result;
}

int main(void) {
    long long n;
    if (!read_number(999999999, &n)) return invalid_input();
    printf("%lld\n", insert_zeros(n));
    return 0;
}
