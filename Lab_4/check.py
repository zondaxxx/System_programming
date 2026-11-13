from pathlib import Path
import random
import subprocess

root = Path(__file__).resolve().parent
checks = 0


def run(task, text, expected=None):
    global checks
    for suffix in ('', '_c'):
        result = subprocess.run(
            [str(root / 'build' / f'task{task}{suffix}')],
            input=text, text=True, capture_output=True, timeout=10
        )
        if expected is None:
            assert result.returncode == 1, (task, suffix, text, result)
            assert result.stderr == 'Invalid input\n', result.stderr
        else:
            assert result.returncode == 0, (task, suffix, text, result.stderr)
            assert result.stdout == expected, (task, suffix, text, result.stdout, expected)
        checks += 1


rng = random.Random(16)
values = [0, 1, 4, 5, 14, 15, 34, 35, 104, 105, 1000000]
values += [rng.randrange(1000001) for _ in range(20)]
for n in values:
    expected = n // 5 - n // 15 - n // 35 + n // 105
    run(6, f'{n}\n', f'{expected}\n')

values = [0, 1, 9, 10, 100, 101, 123, 100000000, 999999999]
values += [rng.randrange(1000000000) for _ in range(30)]
for n in values:
    expected = int(''.join(digit + '0' for digit in str(n)))
    run(8, f'{n}\n', f'{expected}\n')

values = [0, 9, 10, 11, 12, 20, 22, 99, 100, 101, 110, 1000000]
values += [rng.randrange(10000) for _ in range(15)]
for n in values:
    expected = []
    for value in range(10, n + 1):
        digits = str(value)[-2:]
        if '0' not in digits and all(value % int(digit) == 0 for digit in digits):
            expected.append(f'{value}\n')
    run(13, f'{n}\n', ''.join(expected))

for task in (6, 8, 13):
    limit = 999999999 if task == 8 else 1000000
    for text in ('', '\n', '-1\n', '+1\n', 'abc\n', '12x\n', '1 2\n', f'{limit + 1}\n', '9' * 80 + '\n'):
        run(task, text)
    expected = '10\n' if task == 8 else '0\n' if task == 6 else ''
    run(task, '0001', expected)

print(f'Проверено {checks} запусков. Результаты ASM и C совпадают с проверкой.')
