#include <init/pic.h>
#include <init/pit.h>
#include <init/video.h>
#include <task.h>

extern int32_t system_timer_fractions, system_timer_ms, IRQ0_fractions, IRQ0_ms,
    IRQ0_frequency, PIT_reload_value;

extern sheduler_t sheduler;

uint32_t compteur = 0;
uint8_t frequency = 0;
uint8_t status_PIT = 0;

void conserv_status_byte()
{
     set_pit_count(PIT_0, PIT_reload_value);

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);

    compteur++;
    print_frequence(system_timer_ms);
}

void sheduler_cpu_timer()
{
    if (sheduler.init_timer == 1) {
        if (sheduler.task_timer == 0) {
            sheduler.task_timer = DELAY_PER_TASK;
            __switch();
        }
        else
            sheduler.task_timer--;
    }
}

void Init_PIT(uint16_t frequence)
{
    /*
       We should program the PIT channel

       -calibrate the good frequency

       -disable interrupt

       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    calculate_frequency();

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);

    set_pit_count(PIT_0, PIT_reload_value);
}

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    uint8_t command = 0x00;

    switch (channel) {
    case PIT_0:
        command |= READ_BACK_TIMER_0(1);
        break;
    case PIT_1:
        command |= READ_BACK_TIMER_1(1);
        break;

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;

    pit_send_command((uint8_t)command);

    return read_pit_count(PIT_0);
}