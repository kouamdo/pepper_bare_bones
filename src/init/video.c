#include "../../include/init/video.h"
#include <stdarg.h>
#include <stdint.h>
#include <init/io.h>

static int CURSOR_Y = 0;
static int CURSOR_X = 0;

void volatile pepper_screen()
{
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    int i = 0;
    while (i != 160 * 24) {
        screen[i] = ' ';
        screen[i + 1] = 0x0;
        i += 2;
    }
}

void volatile print_frequence(unsigned int freq)
{
    unsigned char* pos = (unsigned char*)(VIDEO_MEM + 160 * 25 - 10);
    unsigned char i = 10;

    while (i > 0) {
        freq %= 10;
        pos[i] = (freq) + 0x30;
        pos[i + 1] = ADVICE_COLOR;
        i -= 2;
    }
}

void volatile kprintf(int nmber_param, ...)
{
    int val = 0;
    va_list ap;
    int i, tab_param[nmber_param];

    va_start(ap, nmber_param);

    for (i = 0; i < nmber_param; i++) {
        tab_param[i] = va_arg(ap, int);
    }

    unsigned char color = (unsigned char)tab_param[0];
    char* string;

    string = (char*)tab_param[1];

    unsigned char j = 2;

    while (*string) {
        if (*string == '%') {
            print_address(color, tab_param[j]);
            j++;
        }
        else
            putchar(color, *string);

        string++;
    }

    va_end(ap);
}

void volatile scrollup()
{
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    unsigned char b[160];
    int i;
    for (i = 0; i < 160; i++)
        b[i] = v[i];

    pepper_screen();

    v = (unsigned char*)(VIDEO_MEM);

    for (i = 0; i < 160; i++)
        v[i] = b[i];

    CURSOR_Y++;
}

void volatile putchar(unsigned char color, unsigned const char c)
{
    if (c == '\n') {
        CURSOR_X = 0;
        CURSOR_Y++;
    }

    else if(c == 0x0D) {
        CURSOR_X--;
        unsigned char* v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
        *v = ' ';
    }

    else if (c == '\t')
        CURSOR_X += 5;

    else {
        unsigned char* v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);

        if (c == '\n' || CURSOR_X == 80) {
            CURSOR_X = 0;
            CURSOR_Y++;
            *(v) = c;
            *(v + 1) = color;
            CURSOR_X++;
        }
        else {
            *(v) = c;
            *(v + 1) = color;
            CURSOR_X++;
        }
    }
}

void volatile print_address(unsigned char color, unsigned int adress__)
{
    char p[10] = {0};


    if (CURSOR_Y >= 25) {
        scrollup();
        CURSOR_X = 0;
        CURSOR_Y = 0;
    }

    else {
        unsigned int i, c;

        c = adress__;

        for (i = 1; i <= 8; i++) {
            adress__ = c % 16;
            c /= 16;

            if (adress__ == 15)
                p[10 - i] |= 'f';

            else if (adress__ == 14)
                p[10 - i] |= 'e';

            else if (adress__ == 13)
                p[10 - i] |= 'd';

            else if (adress__ == 12)
                p[10 - i] |= 'c';

            else if (adress__ == 11)
                p[10 - i] |= 'b';

            else if (adress__ == 10)
                p[10 - i] |= 'a';

            else
                p[10 - i] |= (char)(adress__ + 0x30);
        }
        for (i = 0; i < 10; i++)
            putchar(color, p[i]);
    }
}

void move_cursor(uint8_t x , uint8_t y)
{
    uint16_t c_pos;

    c_pos = y * 80 + x;

	outb(0x3d4, 0x0f);
	outb(0x3d5, (uint8_t) c_pos);
	outb(0x3d4, 0x0e);
	outb(0x3d5, (uint8_t) (c_pos >> 8));
}

void show_cursor(void)
{
	move_cursor(CURSOR_X, CURSOR_Y);
}