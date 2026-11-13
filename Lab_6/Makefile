.PHONY: all check run clean

all: build/Rulev

build:
	mkdir -p build

build/Rulev.o: Rulev.asm | build
	fasm $< $@

build/Rulev: build/Rulev.o
	ld -z noexecstack $< -lc -lncurses -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@

build/check: build/Rulev.o mock.c
	gcc -Wall -Wextra -Werror -nostartfiles -no-pie -Wl,-z,noexecstack $^ -o $@

check: all build/check
	python3 check.py

run: all
	TERM=xterm-256color ./build/Rulev

clean:
	rm -rf build
