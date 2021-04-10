#include "../../include/init/console.h"
#include <stdarg.h>
#include <stdint.h>
#include <init/io.h>

static int CURSOR_Y = 0;
static int CURSOR_X = 0;

void volatile cclean()
{
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    int i = 0;
    while (i != 160 * 24) {
        screen[i] = ' ';
        screen[i + 1] = 0x0;
        i += 2;
    }
    cputchar(READY_COLOR , 'K');
    cputchar(READY_COLOR , '>');
}

void volatile cscrollup()
{
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    unsigned char b[160];
    int i;
    for (i = 0; i < 160; i++)
        b[i] = v[i];

    cclean();

    v = (unsigned char*)(VIDEO_MEM);

    for (i = 0; i < 160; i++)
        v[i] = b[i];

    CURSOR_Y++;
}

void volatile cputchar(unsigned char color, unsigned const char c)
{
    unsigned char* v  ;
    
    if (c == '\n') {
        CURSOR_X = 0;
        CURSOR_Y++;
    }

    else if(c == 0x0D) {
        CURSOR_X--;
        v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
        *v = ' ';
    }

    else if (c == '\t')
        CURSOR_X += 5;

    else {
       v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);

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