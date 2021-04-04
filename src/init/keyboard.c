#include <init/keyboard.h>
#include <stdint.h>
#include <init/video.h>

extern void show_cursor() ;
static void reinitialise_kbd() , void wait () ;



void keyboard_irq()
{
	uint8_t i  , ack;
	static int lshift_enable;
	static int rshift_enable;
	static int alt_enable;
	static int ctrl_enable;

	do {
		i = _8042_get_status;
	} while ((i & 0x01) == _8042_BUFFER_OVERRUN);

	i = _8042_scan_code;
	i--;

	//// putcar('\n'); dump(&i, 1); putcar(' ');

	if (i < 0x80) {		/* touche enfoncee */
		switch (i) {
		case 0x29:
			lshift_enable = 1;
			break;
		case 0x35:
			rshift_enable = 1;
			break;
		case 0x1C:
			ctrl_enable = 1;
			break;
		case 0x37:
			alt_enable = 1;
			break;
		default:
			putchar(READY_COLOR ,  kbdmap
			       [i * 4 + (lshift_enable || rshift_enable)]);
		}
	} else {		/* touche relachee */
		i -= 0x80;
		switch (i) {
		case 0x29:
			lshift_enable = 0;
			break;
		case 0x35:
			rshift_enable = 0;
			break;
		case 0x1C:
			ctrl_enable = 0;
			break;
		case 0x37:
			alt_enable = 0;
			break;
		}
	}

	show_cursor() ;

	reinitialise_kbd();

}


static void reinitialise_kbd()
{
	_8042_send_get_current_scan_code ;
	wait();
	_8042_set_typematic_rate ; 
	wait();
	_8042_set_leds ;
	wait();
	_8042_enable_scanning ;
	wait();
}

static void wait ()
{
	while(_8042_get_status  != _8042_ACK);
}