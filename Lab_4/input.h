#ifndef INPUT_H
#define INPUT_H
#include <stdio.h>

static int read_number(long long limit, long long *result) {
    long long value = 0;
    int c;
    int digits = 0;
    while ((c = getchar()) != '\n' && c != EOF) {
        if (c < '0' || c > '9') return 0;
        value = value * 10 + c - '0';
        if (value > limit) return 0;
        digits++;
    }
    if (!digits || ferror(stdin)) return 0;
    *result = value;
    return 1;
}

static int invalid_input(void) {
    fputs("Invalid input\n", stderr);
    return 1;
}
#endif
