from pathlib import Path
import codecs
import fcntl
import os
import pty
import select
import struct
import subprocess
import termios
import time
import pyte
from PIL import Image, ImageDraw, ImageFont


def save_frame(screen, path):
    cell_w, cell_h = 18, 26
    picture = Image.new('RGB', (screen.columns * cell_w + 32,
                                screen.lines * cell_h + 32), '#111318')
    pen = ImageDraw.Draw(picture)
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 21)
    colors = {'white': '#f2f2f2', 'brown': '#e5c74c', 'yellow': '#e5c74c',
              'default': '#f2f2f2', 'black': '#111318'}
    for row in range(screen.lines):
        for col in range(screen.columns):
            char = screen.buffer[row][col]
            pen.text((16 + col * cell_w, 16 + row * cell_h), char.data,
                     font=font, fill=colors.get(char.fg, char.fg))
    picture.save(path)


out = Path('evidence')
out.mkdir(exist_ok=True)
master, slave = pty.openpty()
fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', 9, 12, 0, 0))
before = termios.tcgetattr(slave)
screen = pyte.Screen(12, 9)
stream = pyte.Stream(screen)
decoder = codecs.getincrementaldecoder('utf-8')('replace')
proc = subprocess.Popen(['./build/Rulev'], stdin=slave, stdout=slave, stderr=slave,
                        env=dict(os.environ, TERM='xterm-256color'))
raw = bytearray()
started = time.monotonic()
sent = 0
white_saved = yellow_saved = False
quit_sent = False
try:
    while time.monotonic() - started < 15:
        elapsed = time.monotonic() - started
        if sent < 2 and elapsed > 0.15 + sent * 0.18:
            os.write(master, b'f')
            sent += 1
        if select.select([master], [], [], 0.02)[0]:
            data = os.read(master, 65536)
            raw.extend(data)
            stream.feed(decoder.decode(data))
        chars = [screen.buffer[y][x] for y in range(9) for x in range(12)]
        white = sum(c.data == '#' and c.fg == 'white' for c in chars)
        yellow = sum(c.data == '#' and c.fg in ('brown', 'yellow') for c in chars)
        if not white_saved and white >= 45 and yellow == 0:
            save_frame(screen, out / 'white.png')
            white_saved = True
        if white_saved and not yellow_saved and yellow >= 30 and white > 0:
            save_frame(screen, out / 'yellow.png')
            yellow_saved = True
            os.write(master, b'p')
            quit_sent = True
        if proc.poll() is not None:
            break
    if proc.poll() is None:
        raise RuntimeError('Программа не завершилась за 15 секунд')
    assert proc.returncode == 0
    assert white_saved and yellow_saved and quit_sent
    assert termios.tcgetattr(slave) == before
finally:
    if proc.poll() is None:
        proc.kill()
        proc.wait()
    os.close(master)
    os.close(slave)
(out / 'terminal.ansi').write_bytes(raw)
print('Программа запущена с ncurses в терминале 12 × 9.')
print('Нажаты f, f, p. Сохранены белый и жёлтый следы.')
print('Выход: код 0. Настройки терминала восстановлены.')
