#ifndef _PIT_H_
#define _PIT_H_

#include <i386types.h>
#include <io.h>

/*
    I/O port     Usage
    0x40         Channel 0 data port (read/write)
    0x41         Channel 1 data port (read/write)
    0x42         Channel 2 data port (read/write)
    0x43         Mode/Command register (write only, a read is ignored)
*/

//  I/O ports for PIT
#define PIT_0 0x40
#define PIT_1 0x41
#define PIT_2 0x42
#define REGISTER_PIT 0x43

// Read back command/mode
// Read back command
/*
    The read back command is a special
     command sent to the mode/command register (I/O port 0x43).
*/
//--------------------------------------------------------------------
// Read back timer channel 0 (1 = yes, 0 = no)
#define READ_BACK_TIMER_0(x) ((x) << 0x1)

// Read back timer channel 1 (1 = yes, 0 = no)
#define READ_BACK_TIMER_1(x) ((x) << 0x2)

// Read back timer channel 2 (1 = yes, 0 = no)
#define READ_BACK_TIMER_2(x) ((x) << 0x3)

// Latch status flag (0 = latch status, 1 = don't latch status)
#define LATCH_STATUS_FLAG(x) ((x) << 0x4)

// Latch count flag (0 = latch count, 1 = don't latch count)
#define LATCH_COUNT_FLAG(x) ((x) << 0x5)

//----------------------------------------------------------------------

/*
    Read Back status byte
    After sending a read back command with bit 4 clear, reading
    the data port for each selected channel will return a status value
*/
//---------------------------------------------------------------------------

// 0 = 16-bit binary, 1 = four-digit BCD
#define BCD_BINARY_MODE(x) x

/*
    Operating mode :
                0 = Mode 0 (interrupt on terminal count)
                1 = Mode 1 (hardware re-triggerable one-shot)
                2 = Mode 2 (rate generator)
                3 = Mode 3 (square wave generator)
                4 = Mode 4 (software triggered strobe)
                5 = Mode 5 (hardware triggered strobe)
                6 = Mode 2 (rate generator, same as 010b)
                7 = Mode 3 (square wave generator, same as 011b)
*/
#define OPERATING_MODE(x) (x << 1)

/*
     Access mode :
                0 = Latch count value command
                1 = Access mode: lobyte only
                2 = Access mode: hibyte only
                3 = Access mode: lobyte/hibyte
*/
#define ACCESS_MODE(x) (x << 4)

// Usage:Nul count flag
#define NULL_COUNT_FLAG(x) (x << 6)

// Usage:Output pin state
#define OUTPUT_PIN_STATE(x) (x << 7)

// Select channel 0
#define CHANNEL_0 0

// Select channel 1
#define CHANNEL_1 1

// Select channel 2
#define CHANNEL_2 2

// Select read back command
#define READ_BACK_COMMAND 0xC0

//---------------------------------------------------------------------------

// Pour connaître le statut d'une seule chaine
// On pourra déterminer le statut d'un channel avant de configurer le channel
// Ne pas confondre le statut d'un channel et sa donnée
int8_t read_back_channel(int8_t channel);

// Programmer une chaine PIT
// Prenant en parametre un compteur

void PIT_channel(int8_t counter), Init_PIT(uint16_t _frequency);

extern void irq_PIT(), calculate_frequency();

/*
 * Send Latch command
 * When the latch command has been sent,
 * the current count is copied into an internal "latch register"
 */

#define send_latch_command(channel) \
    outb(REGISTER_PIT, 0b00000000 | ((channel && 0x03) << 6));
/*
 *   Reading the current count
 * For the "lobyte/hibyte" access mode you need to send
 * the latch command (described above) to avoid getting wrong results.
 * If any other code could try set the PIT channel's
 * reload value or read its current count after you've
 * sent the latch command but before you've read the highest 8 bits,
 * then you have to prevent it.
 */
#define read_pit_count(channel)      \
    ({                               \
        int8_t byte[2];              \
        send_latch_command(channel); \
        byte[0] = inb(channel);      \
        byte[1] = inb(channel);      \
        (uint16_t) * (byte);         \
    })
/*
 *   Setting the current count
 * For the "lobyte/hibyte" access mode
 * you need to send the low 8 bits followed by the high 8 bits.
 * You must prevent other code from setting the PIT channel's
 * reload value or reading its current count once you've sent the lowest 8 bits.
 */
#define set_pit_count(channel, data)        \
    ({                                      \
        outb(channel, (int8_t)(data));      \
        outb(channel, (int8_t)(data >> 8)); \
    })

// Envoyer une commande au PIT
#define pit_send_command(cmd) set_pit_count(REGISTER_PIT, cmd);

#endif