.PHONY: all check clean

all: build/task1_reverse build/task2_matrix build/task3_triangle build/task4_digit_sum build/task4_digit_sum_stripped build/task5_digit_sum build/task5_digit_sum_Os

build:
	mkdir -p build

build/%.o: %.asm | build
	fasm $< $@

build/task1_reverse build/task2_matrix build/task3_triangle build/task4_digit_sum: build/%: build/%.o
	ld -z noexecstack -o $@ $<

build/task4_digit_sum_stripped: build/task4_digit_sum
	strip -o $@ $<

build/task5_digit_sum: task5_digit_sum.c | build
	gcc -std=c11 -Wall -Wextra -Werror -O0 $< -o $@

build/task5_digit_sum_Os: task5_digit_sum.c | build
	gcc -std=c11 -Wall -Wextra -Werror -Os -s $< -o $@

check: all
	python3 check.py

clean:
	rm -rf build
