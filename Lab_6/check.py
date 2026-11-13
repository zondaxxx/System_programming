import os
import subprocess


def run(cols, rows, draws, **extra):
    env = dict(os.environ, COLS_TEST=str(cols), ROWS_TEST=str(rows),
               DRAWS_TEST=str(draws), **extra)
    result = subprocess.run(['./build/check'], env=env, text=True,
                            capture_output=True, timeout=5, check=True)
    lines = result.stdout.splitlines()
    assert lines[:2] == ['pair 1 7 0', 'pair 2 3 0']
    assert lines[-1] == 'endwin'
    points = [tuple(map(int, line.split()[1:])) for line in lines
              if line.startswith('draw ')]
    delays = [int(line.split()[1]) for line in lines if line.startswith('delay ')]
    return points, delays, lines


def expected(width, height):
    x, y = (width - 1) // 2, height // 2
    points = [(x, y)]
    for length in range(1, 2 * max(width, height) + 1):
        directions = [(0, -1), (1, 0)] if length % 2 else [(0, 1), (-1, 0)]
        for dx, dy in directions:
            for _ in range(length):
                x, y = x + dx, y + dy
                if not (0 <= x < width and 0 <= y < height):
                    return points
                points.append((x, y))


total = 0
for cols, rows in [(6, 5), (8, 7), (14, 7), (7, 4), (2, 1), (2, 7), (8, 1)]:
    path = expected(cols - 1, rows)
    points, delays, _ = run(cols, rows, 2 * len(path) + 1)
    wanted = [(x, y, ord('#') | color) for color in (0x100, 0x200)
              for x, y in path] + [(path[0][0], path[0][1], ord('#') | 0x100)]
    assert points == wanted, (cols, rows, points, wanted)
    assert len(set(path)) == len(path)
    assert delays == [80] * len(points)
    total += 1

points, delays, _ = run(6, 5, 6, SPEED_TEST='1')
assert delays == [80, 40, 20, 160, 80, 80], delays
total += 1
points, _, lines = run(6, 5, 6, RESIZE_TEST='1')
assert [(x, y) for x, y, _ in points[2:]] == expected(7, 7)[:4]
assert lines.count('clear') == 2
total += 1
print(f'Проверки движения, цветов, скорости, размеров окна и выхода: {total} из {total}.')
