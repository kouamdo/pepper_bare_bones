#ifndef _TASK_H_

#define _TASK_H_

#include <i386types.h>
#include <init/gdt.h>

typedef uint32_t pid_t;
#define DELAY_PER_TASK 300
// State of task
typedef enum state { running,
                     ready,
                     blocked,
                     Nil } state_t;

typedef struct cpu_task_info {
    uint32_t eax, ebx, ecx, edx, esi, edi, esp, ebp, eip, eflags, cr3;
    uint16_t es, gs, fs, cs;
} __attribute__((packed)) registers_t;

typedef struct task_control_block {
    registers_t                regs;
    state_t                    state_task;
    pid_t                      pid;
    struct task_control_block* new_tasks; // field that can be used for multiple different linked lists of tasks later on

} __attribute__((packed)) task_control_block_t;

// Sheduler and sheduling algorithm
typedef struct sheduler {
    uint8_t               init_timer;
    uint32_t              task_timer;
    task_control_block_t* running_task;
} sheduler_t;

// Prepare and switch to another task
void __switch();

// task actually using by CPU
void task_running(task_control_block_t task_);

// task unable to run until some external event happens
void task_blocked(task_control_block_t task_);

// tasks runnable
void task_ready(task_control_block_t task_);

/*
    task transitions
*/

// task block for input
void task_running_blocked(task_control_block_t task_);

// sheduler picks another task
void running_ready(task_control_block_t task_);

// sheduler picks this process
void ready_running(task_control_block_t task_);

// input becomes available
void blocked_ready(task_control_block_t task_);

extern void switch_to_task(registers_t*, registers_t*);
void        init_multitasking();
void        create_task(task_control_block_t*, void (*)(), uint32_t, uint32_t);
void        yeild();
#endif // !_TASK_H_
