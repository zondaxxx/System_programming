.PHONY: all check clean

all: build/task6 build/task8 build/task13 build/task6_c build/task8_c build/task13_c

build:
	mkdir -p build

build/%.o: %.asm io.inc | build
	fasm $< $@

build/task%: build/task%.o
	ld -z noexecstack -o $@ $<

build/task%_c: task%.c input.h | build
	gcc -std=c11 -Wall -Wextra -O0 $< -o $@

check: all
	python3 check.py

clean:
	rm -rf build
