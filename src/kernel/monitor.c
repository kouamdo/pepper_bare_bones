#include <init/keyboard.h>
#include <kernel/printf.h>
#include <lib.h>
#include <stdint.h>
#include <string.h>

extern uint8_t* _KBD_BUFFER;
extern uint8_t  size_buffer_inside;

int mon_help(int argc, char** argv);
int backtrace(int argc, char** argv);

struct Command {
    const char* name;
    const char* desc;
    // return -1 to force monitor to exit
    int (*func)(int argc, char** argv);
};

static struct Command commands[]
    = {
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;

    while (ebp != 0) {
        kprintf("ebp %x eip %x\n", ebp, *eip);

        ptr = (int*)(ebp);

        ebp = (int)(*ptr);

        eip = (int*)(ebp + 4);
    }
    return 0;
}

int mon_help(int argc, char** argv)
{
    int i;

    for (i = 0; i < 2; i++)
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    return 0;
}

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    int8_t code = get_ASCII_code_keyboard();
    if (code != '\n') {
        keyboard_code_monitor[keyboard_num] = code;
        keyboard_num++;
    }

    else {
        int i;
        for (i = 0; i < keyboard_num; i++) {
            putchar(keyboard_code_monitor[i]);
            keyboard_code_monitor[i] = 0;
        }

        keyboard_num = 0;
    }
}