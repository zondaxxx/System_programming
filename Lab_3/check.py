from pathlib import Path
import random
import subprocess

root = Path(__file__).resolve().parent
count = 0


def run(name, args, expected=None):
    global count
    result = subprocess.run(
        [str(root / 'build' / name), *map(str, args)],
        capture_output=True, text=True, timeout=3
    )
    if expected is None:
        assert result.returncode == 1, (name, args, result)
        assert result.stdout == '' and result.stderr == 'Error: invalid input\n'
    else:
        assert result.returncode == 0, (name, args, result)
        assert result.stdout == f'{expected}\n', (name, args, result.stdout, expected)
        assert result.stderr == ''
    count += 1


def divide(a, b):
    value = abs(a) // abs(b)
    return -value if (a < 0) != (b < 0) else value


for value in range(1, 128):
    run('task1', [chr(value)], value)
for args in ([], [''], ['AB'], ['А'], ['é'], ['A', 'B']):
    run('task1', args)

values = [
    (1, 7, 1), (-1, 7, 1), (1, -7, -1), (-1, -7, -1),
    (2, 7, 1), (1, 7, 2), (20, 3, 4),
    (1000000000, -1000000000, 1000000000),
    (-1000000000, 1000000000, -1000000000),
]
rng = random.Random(16)
for _ in range(100):
    values.append(tuple(rng.choice([*range(-15, 0), *range(1, 16)]) for _ in range(3)))

for a, b, c in values:
    expected = divide(divide(divide(divide(b, b), a), a), c)
    for name in ('task2', 'task2_c'):
        run(name, [a, b, c], expected)

invalid = [
    [], [1, 2], [1, 2, 3, 4], [0, 2, 3], [1, 0, 3], [1, 2, 0],
    ['', 2, 3], ['-', 2, 3], ['+', 2, 3], ['1x', 2, 3], [' 1', 2, 3],
    ['1.5', 2, 3], [1000000001, 2, 3], [-1000000001, 2, 3],
    [1, '99999999999999999999999999999', 1], [1, 2, '--1'],
]
for name in ('task2', 'task2_c'):
    run(name, ['+1', '-0007', '-1'], -1)
    for args in invalid:
        run(name, args)

print(f'Проверки пройдены: {count}')
