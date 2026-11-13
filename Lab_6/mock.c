#include <stdio.h>
#include <stdlib.h>

void *stdscr = (void *)1;
static int width, height, count, position_x, position_y, draws;

void *initscr(void) {
    width = atoi(getenv("COLS_TEST"));
    height = atoi(getenv("ROWS_TEST"));
    draws = atoi(getenv("DRAWS_TEST"));
    return stdscr;
}
int start_color(void) { return 0; }
int noecho(void) { return 0; }
int cbreak(void) { return 0; }
int getmaxx(void *window) { (void)window; return width; }
int getmaxy(void *window) { (void)window; return height; }
int clear(void) { puts("clear"); return 0; }
int init_pair(short pair, short front, short back) {
    printf("pair %d %d %d\n", pair, front, back);
    return 0;
}
int move(int y, int x) {
    position_x = x;
    position_y = y;
    return 0;
}
int addch(unsigned int value) {
    printf("draw %d %d %u\n", position_x, position_y, value);
    ++count;
    return 0;
}
int refresh(void) { return 0; }
void timeout(int delay) { printf("delay %d\n", delay); }
int getch(void) {
    if (count >= draws) return 'p';
    if (getenv("RESIZE_TEST") && count == 2) {
        width = 8;
        height = 7;
    }
    if (getenv("SPEED_TEST") && count <= 4) return 'f';
    return -1;
}
int endwin(void) { puts("endwin"); return 0; }
