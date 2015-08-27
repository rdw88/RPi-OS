from PIL import Image
import sys
import array

CHARS_PER_LINE = 8
NUM_ROWS = 16
CHAR_PIXEL_WIDTH = 8
CHAR_PIXEL_HEIGHT = 16
NUM_CHARS = 128


def export(pixels, output):
    image_bytes = list()

    for i in range(NUM_ROWS):
        yPixelOffset = i * CHAR_PIXEL_HEIGHT

        for k in range(CHARS_PER_LINE):
            xPixelOffset = k * CHAR_PIXEL_WIDTH

            for y in range(yPixelOffset, yPixelOffset + CHAR_PIXEL_HEIGHT):
                byte = 0

                for x in range(xPixelOffset, xPixelOffset + CHAR_PIXEL_WIDTH):
                    if pixels[x, y][0] == 0:
                        place = x % 8
                        bit = 0x01 << (7 - place)
                        byte = byte | bit

                image_bytes.append(byte)

    raw_bytes = array.array('B', image_bytes).tostring()
    with open(output, 'wb') as f:
        f.write(raw_bytes)
        f.close()



if __name__=='__main__':
    if len(sys.argv) < 3:
        print 'Need to supply src, dest files. Src should be a PNG file containing font drawings, DEST a binary file.'
        print 'python exportfont.py SRC DEST'
        sys.exit(1)

    src = sys.argv[1]
    dest = sys.argv[2]

    im = Image.open(src)
    pixels = im.load()

    if im.size[0] * im.size[1] != CHAR_PIXEL_WIDTH * CHAR_PIXEL_HEIGHT * NUM_CHARS:
        print 'Invalid image size. Image should contain 8x16 pixel chars, 128 chars.'
        sys.exit(1)

    export(pixels, dest)
    print 'Exported binary data to %s' % dest
