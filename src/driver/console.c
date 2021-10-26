#include <driver/console.h>
#include <driver/keyboard.h>
#include <stdint.h>

#define MAX_ROWS 25
#define MAX_COLS 80

static int CURSOR_Y = 0;
static int CURSOR_X = 0;

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    int            i      = 0;
    while (i <= 160 * 25) {
        screen[i]     = ' ';
        screen[i + 1] = 0x0;
        i += 2;
    }

    CURSOR_X = 0;
    CURSOR_Y = 0;
}

void volatile cscrollup()
{
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
        b[i] = v[i];

    cclean();

    v = (unsigned char*)(VIDEO_MEM);

    for (i = 0; i < 160; i++)
        v[i] = b[i];

    CURSOR_Y++;
}

void volatile cputchar(char color, const char c)
{

    if ((CURSOR_Y) <= (25)) {
        if (c == '\n') {
            CURSOR_X = 0;
            CURSOR_Y++;
        }

        else if (c == '\t')
            CURSOR_X += 5;

        else if (c == 0x08)

        {
            CURSOR_X--;
            uint8_t* v = (uint8_t*)VIDEO_MEM;

            v += 2 * CURSOR_X + 160 * CURSOR_Y;

            *v = ' ';
        }

        else {
            uint8_t* v = (uint8_t*)VIDEO_MEM;

            v += 2 * CURSOR_X + 160 * CURSOR_Y;

            *v = c;

            *(v + 1) = READY_COLOR;

            CURSOR_X++;
        }
    }

    else
        cclean();
}

void move_cursor(uint8_t x, uint8_t y)
{
    uint16_t c_pos;

    c_pos = y * 80 + x;

    outb(0x3d4, 0x0f);
    outb(0x3d5, (uint8_t)c_pos);
    outb(0x3d4, 0x0e);
    outb(0x3d5, (uint8_t)(c_pos >> 8));
}

void show_cursor(void)
{
    move_cursor(CURSOR_X, CURSOR_Y);
}

void console_service_keyboard()
{
    if (get_ASCII_code_keyboard() != 0) {
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
        show_cursor();
    }
}

void init_console()
{
    cclean();
    kbd_init(); //Init keyboard
    //init Video graphics here
}