.PHONY: all check clean

all: build/task1 build/task2 build/task2_c

build:
	mkdir -p build

build/%.o: %.asm io.inc | build
	fasm $< $@

build/task1: build/task1.o
	ld -z noexecstack -o $@ $<

build/task2: build/task2.o
	ld -z noexecstack -o $@ $<

build/task2_c: task2.c | build
	gcc -std=c11 -Wall -Wextra -Werror -O0 $< -o $@

check: all
	python3 check.py

clean:
	rm -rf build
