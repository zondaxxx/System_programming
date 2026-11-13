#include <stdio.h>

int parse_number(const char *s, long long *result) {
    long long value = 0;
    int sign = 1;
    if (*s == '-' || *s == '+') {
        if (*s == '-') sign = -1;
        ++s;
    }
    if (*s == '\0') return 0;
    while (*s) {
        if (*s < '0' || *s > '9') return 0;
        value = value * 10 + *s - '0';
        if (value > 1000000000) return 0;
        ++s;
    }
    *result = value * sign;
    return 1;
}

int main(int argc, char **argv) {
    long long a, b, c;
    if (argc != 4 || !parse_number(argv[1], &a) ||
        !parse_number(argv[2], &b) || !parse_number(argv[3], &c) ||
        a == 0 || b == 0 || c == 0) {
        fputs("Error: invalid input\n", stderr);
        return 1;
    }
    printf("%lld\n", (((b / b) / a) / a) / c);
    return 0;
}
