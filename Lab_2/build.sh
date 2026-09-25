#!/bin/bash
# Лабораторная работа №2. Сборка всех заданий и сравнение размеров файлов.
set -e
cd "$(dirname "$0")"

# Задания 1-4: fasm -> объектный файл -> ld -> исполняемый файл
for t in task1_reverse task2_matrix task3_triangle task4_digit_sum; do
    fasm "$t.asm" > /dev/null
    ld "$t.o" -o "$t"
done

# Задание 5: обычная версия на C
gcc task5_digit_sum.c -o task5_digit_sum

# Задание 5: сокращение размера
# C: оптимизация по размеру + удаление символов
gcc -Os -s task5_digit_sum.c -o task5_digit_sum_Os
# C: без libc, без стартового кода, прямые системные вызовы
gcc -Os -s -static -nostdlib -fno-asynchronous-unwind-tables -fno-stack-protector \
    -Wl,--gc-sections -Wl,--build-id=none -Wl,-N task5_min.c -o task5_min_c
# asm: удаление таблицы символов из обычной версии
strip -o task4_digit_sum_stripped task4_digit_sum
# asm: компоновка без выравнивания секций на страницы (-N) и без символов (-s)
ld -N -s task4_digit_sum.o -o task4_digit_sum_N
# asm: fasm сразу формирует исполняемый ELF без линковщика
fasm task5_min64.asm task5_min64 > /dev/null
fasm task5_min32.asm task5_min32 > /dev/null
chmod +x task5_min64 task5_min32

echo "Размеры исполняемых файлов (байт):"
ls -l task4_digit_sum task4_digit_sum_stripped task4_digit_sum_N task5_min64 task5_min32 \
      task5_digit_sum task5_digit_sum_Os task5_min_c | awk '{printf "%8d  %s\n", $5, $9}'
