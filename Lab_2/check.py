from pathlib import Path
import subprocess


def run(name):
    result = subprocess.run([str(Path('build') / name)], capture_output=True,
                            text=True, timeout=5, check=True)
    assert not result.stderr, result.stderr
    return result.stdout


text = 'TTaQgEqQJZdfGgqazcJpCDzwNgDdwpM'
assert run('task1_reverse') == f'S          = {text}\nS reversed = {text[::-1]}\n'
print('Задание 1: строка выведена в обратном порядке.')

matrix = run('task2_matrix')
assert matrix == (';' * 12 + '\n') * 25
assert matrix.count(';') == 300
print('Задание 2: 25 строк по 12 символов, всего 300.')

triangle = run('task3_triangle')
assert triangle == ''.join(';' * n + '\n' for n in range(1, 25))
assert triangle.count(';') == 300
print('Задание 3: 24 строки, всего 300 символов.')

expected = sum(map(int, str(2710058798)))
for name in ['task4_digit_sum', 'task4_digit_sum_stripped',
             'task5_digit_sum', 'task5_digit_sum_Os']:
    assert run(name) == f'Sum of digits of 2710058798 = {expected}\n'
print('Задания 4 и 5: сумма цифр равна 47 во всех четырёх сборках.')

assert Path('build/task4_digit_sum_stripped').stat().st_size < Path('build/task4_digit_sum').stat().st_size
assert Path('build/task5_digit_sum_Os').stat().st_size < Path('build/task5_digit_sum').stat().st_size
print('Размеры программ на ASM и C уменьшены. Все 7 запусков прошли проверку.')
