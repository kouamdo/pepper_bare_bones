#include <init/keyboard.h>

static kbd_8042_t keyboard_ctrl; //Keyboard services control

void        reinitialise_kbd();
static void wait_8042_ACK();

static int8_t lshift_enable;
static int8_t rshift_enable;
static int8_t alt_enable;
static int8_t ctrl_enable;

extern void show_cursor();

//Add all services here
extern void console_service_keyboard(),
    monitor_service_keyboard();

static uint8_t kbdmap[]
    = {
          0x1B, 0x1B, 0x1B, 0x1B, /*      esc     (0x01)  */
          '1', '!', '1', '1',
          '2', '@', '2', '2',
          '3', '#', '3', '3',
          '4', '$', '4', '4',
          '5', '%', '5', '5',
          '6', '^', '6', '6',
          '7', '&', '7', '7',
          '8', '*', '8', '8',
          '9', '(', '9', '9',
          '0', ')', '0', '0',
          '-', '_', '-', '-',
          '=', '+', '=', '=',
          0x08, 0x08, 0x7F, 0x08, /*      backspace       */
          0x09, 0x09, 0x09, 0x09, /*      tab     */
          'q', 'Q', 'q', 'q',
          'w', 'W', 'w', 'w',
          'e', 'E', 'e', 'e',
          'r', 'R', 'r', 'r',
          't', 'T', 't', 't',
          'y', 'Y', 'y', 'y',
          'u', 'U', 'u', 'u',
          'i', 'I', 'i', 'i',
          'o', 'O', 'o', 'o',
          'p', 'P', 'p', 'p',
          '[', '{', '[', '[',
          ']', '}', ']', ']',
          0x0A, 0x0A, 0x0A, 0x0A, /*      enter   */
          0xFF, 0xFF, 0xFF, 0xFF, /*      ctrl    */
          'a', 'A', 'a', 'a',
          's', 'S', 's', 's',
          'd', 'D', 'd', 'd',
          'f', 'F', 'f', 'f',
          'g', 'G', 'g', 'g',
          'h', 'H', 'h', 'h',
          'j', 'J', 'j', 'j',
          'k', 'K', 'k', 'k',
          'l', 'L', 'l', 'l',
          ';', ':', ';', ';',
          0x27, 0x22, 0x27, 0x27, /*      '"      */
          '`', '~', '`', '`',     /*      `~      */
          0xFF, 0xFF, 0xFF, 0xFF, /*      Lshift  (0x2a)  */
          '\\', '|', '\\', '\\',
          'z', 'Z', 'z', 'z',
          'x', 'X', 'x', 'x',
          'c', 'C', 'c', 'c',
          'v', 'V', 'v', 'v',
          'b', 'B', 'b', 'b',
          'n', 'N', 'n', 'n',
          'm', 'M', 'm', 'm',
          0x2C, 0x3C, 0x2C, 0x2C, /*      ,<      */
          0x2E, 0x3E, 0x2E, 0x2E, /*      .>      */
          0x2F, 0x3F, 0x2F, 0x2F, /*      /?      */
          0xFF, 0xFF, 0xFF, 0xFF, /*      Rshift  (0x36)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x37)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x38)  */
          ' ', ' ', ' ', ' ',     /*      space   */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3a)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3b)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3c)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3d)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3e)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x3f)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x40)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x41)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x42)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x43)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x44)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x45)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x46)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x47)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x48)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x49)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4a)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4b)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4c)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4d)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4e)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x4f)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x50)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x51)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x52)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x53)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x54)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x55)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x56)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x57)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x58)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x59)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5a)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5b)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5c)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5d)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5e)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x5f)  */
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    keyboard_ctrl.kbd_service_num++;
}

void kbd_init()
{
    keyboard_ctrl.kbd_service_num = 0;
    keyboard_add_service(console_service_keyboard);
    keyboard_add_service(monitor_service_keyboard);
}

void keyboard_irq()
{

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);

    keyboard_ctrl.code = _8042_scan_code;

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
        func = keyboard_ctrl.kbd_service[i];
        func();
    }
}

void reinitialise_kbd()
{
    wait_8042_ACK();
    _8042_send_get_current_scan_code;
    wait_8042_ACK();

    _8042_set_typematic_rate;
    wait_8042_ACK();

    _8042_set_leds;
    wait_8042_ACK();

    _8042_enable_scanning;
    wait_8042_ACK();
}

static void
wait_8042_ACK()
{
    while (_8042_get_status != _8042_ACK)
        ;
}

int16_t get_code_kbd_control()
{
    return keyboard_ctrl.code;
}

static void handle_ASCII_code_keyboard()
{
    int16_t _code = keyboard_ctrl.code - 1;

    if (_code < 0x80) { /* key held down */
        switch (_code) {
        case 0x29: lshift_enable = 1; break;
        case 0x35: rshift_enable = 1; break;
        case 0x1C: ctrl_enable = 1; break;
        case 0x37: alt_enable = 1; break;
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
        }
    } else {
        _code -= 0x80;
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
        switch (_code) {
        case 0x29: lshift_enable = 0; break;
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}

int8_t get_ASCII_code_keyboard()
{

    handle_ASCII_code_keyboard();

    return keyboard_ctrl.ascii_code_keyboard;
}