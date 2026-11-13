.PHONY: all check clean

all: build/task6 build/task8

build:
	mkdir -p build

build/%.o: %.asm io.inc | build
	fasm $< $@

build/task%: build/task%.o
	ld -z noexecstack -o $@ $<

check: all
	python3 check.py

clean:
	rm -rf build
