#!/usr/bin/env python3
"""Generate placeholder art: icon.png and the 8-slot Joker sheets.

Standard library only. Run from the repo root:
    python3 tools/make_placeholders.py
It overwrites icon.png and assets/{1x,2x}/jokers.png, so do not run it once
real art is in place.
"""
import struct
import zlib

CELL_W, CELL_H, COLS, ROWS = 71, 95, 4, 2
BLUE = (0, 157, 255, 255)
DARK = (20, 40, 70, 255)
WHITE = (255, 255, 255, 255)
CLEAR = (0, 0, 0, 0)

FONT = {  # 3x5 glyphs, one string per row
    "1": ["010", "110", "010", "010", "111"],
    "2": ["111", "001", "111", "100", "111"],
    "3": ["111", "001", "111", "001", "111"],
    "4": ["101", "101", "111", "001", "001"],
    "5": ["111", "100", "111", "001", "111"],
    "6": ["111", "100", "111", "101", "111"],
    "7": ["111", "001", "010", "010", "010"],
    "8": ["111", "101", "111", "101", "111"],
    "X": ["101", "101", "010", "101", "101"],
}


def write_png(path, width, height, pixels):
    def chunk(tag, data):
        body = tag + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body))

    raw = b"".join(
        b"\x00" + bytes(c for px in pixels[y * width:(y + 1) * width] for c in px)
        for y in range(height)
    )
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)))
        f.write(chunk(b"IDAT", zlib.compress(raw, 9)))
        f.write(chunk(b"IEND", b""))


def rect(pixels, width, x0, y0, w, h, colour):
    for y in range(y0, y0 + h):
        for x in range(x0, x0 + w):
            pixels[y * width + x] = colour


def glyph(pixels, width, char, x0, y0, size, colour):
    for gy, row in enumerate(FONT[char]):
        for gx, bit in enumerate(row):
            if bit == "1":
                rect(pixels, width, x0 + gx * size, y0 + gy * size, size, size, colour)


def joker_sheet(scale):
    cw, ch = CELL_W * scale, CELL_H * scale
    width, height = cw * COLS, ch * ROWS
    pixels = [CLEAR] * (width * height)
    for i in range(COLS * ROWS):
        ox, oy = (i % COLS) * cw, (i // COLS) * ch
        m, b = 2 * scale, 3 * scale
        rect(pixels, width, ox + m, oy + m, cw - 2 * m, ch - 2 * m, WHITE)
        rect(pixels, width, ox + m + b, oy + m + b, cw - 2 * (m + b), ch - 2 * (m + b), BLUE)
        s = 5 * scale
        glyph(pixels, width, "X", ox + cw // 2 - 4 * s, oy + ch // 2 - (5 * s) // 2, s, WHITE)
        glyph(pixels, width, str(i + 1), ox + cw // 2 + s, oy + ch // 2 - (5 * s) // 2, s, WHITE)
    return width, height, pixels


def icon():
    size = 256
    pixels = [DARK] * (size * size)
    rect(pixels, size, 16, 16, size - 32, size - 32, BLUE)
    s = 36
    glyph(pixels, size, "X", size // 2 - (3 * s) // 2, size // 2 - (5 * s) // 2, s, WHITE)
    return size, size, pixels


if __name__ == "__main__":
    write_png("icon.png", *icon())
    write_png("assets/1x/jokers.png", *joker_sheet(1))
    write_png("assets/2x/jokers.png", *joker_sheet(2))
