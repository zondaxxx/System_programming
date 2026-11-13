from pathlib import Path
import os
import random
import subprocess
import tempfile

root = Path(__file__).resolve().parent
consonants = set(b'BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz')
count = 0


def run(name, arguments, success=True):
    global count
    result = subprocess.run([str(root / 'build' / name), *map(str, arguments)], capture_output=True, timeout=10)
    assert result.returncode == (0 if success else 1), (name, result.returncode, result.stderr)
    count += 1
    return result


with tempfile.TemporaryDirectory() as directory:
    work = Path(directory)
    first = work / 'first.txt'
    second = work / 'second.txt'
    output = work / 'output.txt'
    rng = random.Random(16)
    alphabet = b'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 \n\t.,!?'
    samples = [b'', b'AEIOUaeiou', b'Yy', b'Hello, World! 123\n', bytes(range(256)), b'B' * 8193]
    samples += [bytes(rng.choice(alphabet) for _ in range(size)) for size in (1, 17, 4095, 4096, 4097, 17000)]
    for data in samples:
        first.write_bytes(data)
        output.unlink(missing_ok=True)
        run('task6', [first, output])
        expected = b''.join(bytes([value]) * (2 if value in consonants else 1) for value in data)
        assert output.read_bytes() == expected
        assert first.read_bytes() == data

    pairs = [(b'', b''), (b'abc', b''), (b'', b'abc'), (b'aaaa', b'aaa'), (b'abc', b'XYZ'), (b'abracadabra\n', b'barbecue\n'), (b' \n\t!11', b'1!\t\n '), (bytes(range(256)) * 33, bytes(range(255, -1, -1)))]
    pairs += [(bytes(rng.choice(alphabet) for _ in range(size)), bytes(rng.choice(alphabet) for _ in range(size + 7))) for size in (1, 4095, 4096, 4097, 17000)]
    for a, b in pairs:
        first.write_bytes(a)
        second.write_bytes(b)
        output.unlink(missing_ok=True)
        run('task8', [first, second, output])
        expected = bytes(dict.fromkeys(value for value in a if value in set(b)))
        assert output.read_bytes() == expected
        assert first.read_bytes() == a
        assert second.read_bytes() == b

    for name, arguments in [('task6', []), ('task6', [first]), ('task6', [first, second, output]), ('task8', []), ('task8', [first, second]), ('task8', [first, second, output, output])]:
        run(name, arguments, False)

    first.write_bytes(b'Hello, World!')
    second.write_bytes(b'World')
    for name in ('task6', 'task8'):
        inputs = [first] if name == 'task6' else [first, second]
        output.unlink(missing_ok=True)
        run(name, [work / 'missing.txt', *inputs[1:], output], False)
        assert not output.exists()
        run(name, [*inputs, work / 'missing' / 'out.txt'], False)
        output.write_bytes(b'Keep this data')
        run(name, [*inputs, output], False)
        assert output.read_bytes() == b'Keep this data'
        run(name, [*inputs, first], False)
        assert first.read_bytes() == b'Hello, World!'
        link = work / 'link.txt'
        os.link(first, link)
        run(name, [*inputs, link], False)
        assert first.read_bytes() == b'Hello, World!'
        link.unlink()
        link.symlink_to(first)
        run(name, [*inputs, link], False)
        assert first.read_bytes() == b'Hello, World!'
        link.unlink()

    run('task8', [first, second, second], False)
    assert second.read_bytes() == b'World'
    output.unlink(missing_ok=True)
    run('task8', [first, work / 'missing.txt', output], False)
    assert not output.exists()

print(f'Проверок пройдено: {count}. Результаты обеих программ верны.')
