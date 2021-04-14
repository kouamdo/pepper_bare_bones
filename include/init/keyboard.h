#ifndef KEYBOARD_H

#define KEYBOARD_H
#include <init/io.h>
#include <stdint.h>

#define _8042_SEND_RECEIVE_DATA 0X60
#define _8042_COMMAND_STATUS    0x64

#define _8042_get_status inb(_8042_COMMAND_STATUS)

#define _8042_scan_code inb(_8042_SEND_RECEIVE_DATA)

#define _8042_send_command(cmd) outb(_8042_COMMAND_STATUS, cmd)

#define _8042_BUFFER_OVERRUN  0X0  //Key detection error or internal buffer overrun
#define _8042_SELFTEST_PASSED 0XAA //Self test passed (sent after "0xFF (reset)" command or keyboard power up)
#define _8042_ACK             0XFA //Command acknowledged (ACK)
#define _8042_RESEND          0XFE //Resend (keyboard wants controller to repeat last command it sent)
#define _8042_DETECTION_ERROR 0xFF // 	Key detection error or internal buffer overrun

//Set LEDs
#define _8042_set_leds outb(_8042_COMMAND_STATUS, 0xED)

//Set typematic rate and delay
#define _8042_set_typematic_rate outb(_8042_COMMAND_STATUS, 0xF3);

//Echo (for diagnostic purposes, and useful for device removal detection)
#define _8042_send_echo outb(_8042_COMMAND_STATUS, 0xEE)

// Get/set current scan code set
#define _8042_send_get_current_scan_code outb(_8042_COMMAND_STATUS, 0xF0)

//Enable scanning (keyboard will send scan codes)
#define _8042_enable_scanning outb(_8042_COMMAND_STATUS, 0xF4)

/*
		Disable scanning (keyboard won't send scan codes)

		Note: May also restore default parameters
	*/
#define _8042_disable_scanning outb(_8042_COMMAND_STATUS, 0xF5)

//Set default parameters
#define _8042_set_default_param outb(_8042_COMMAND_STATUS, 0xF6)

//Resend last byte
#define _8042_resend_last_byte outb(_8042_COMMAND_STATUS, 0xFE)

//Reset and start self-test
#define _8042_reset_start_seltest outb(_8042_COMMAND_STATUS, 0xFF)

void reinitialise_kbd();                   //Reinitialise keyboard
void kbd_init();                           //Initialise keyboard services
void keyboard_add_service(void (*func)()); //Add keyboard services

#define KBD_BUFF_SIZE 0xFF //number services Max
typedef struct kdb_8042_ {
    int8_t  ascii_code_keyboard;        //GETTING CODE ascii
    int8_t  kbd_service_num;            // number of Service activated
    void*   kbd_service[KBD_BUFF_SIZE]; // List of service for keyword
    int16_t code;                       // Code input
} __attribute__((packed)) kbd_8042_t;

int16_t get_code_kbd_control();
int8_t  get_ASCII_code_keyboard();
void    keyboard_add_service(void (*func)());

#endif