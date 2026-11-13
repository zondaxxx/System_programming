static void sys_write(const char *buf, unsigned long len)
{
    __asm__ volatile ("syscall"
                      : : "a"(1), "D"(1), "S"(buf), "d"(len)
                      : "rcx", "r11", "memory");
}

static void sys_exit(void)
{
    __asm__ volatile ("syscall" : : "a"(60), "D"(0));
    __builtin_unreachable();
}

void _start(void)
{
    unsigned long n = 2710058798UL;
    unsigned int sum = 0;
    char buf[12];
    int i = sizeof buf;

    while (n) {
        sum += n % 10;
        n /= 10;
    }
    buf[--i] = '\n';
    do {
        buf[--i] = '0' + sum % 10;
        sum /= 10;
    } while (sum);
    sys_write(buf + i, sizeof buf - i);
    sys_exit();
}
