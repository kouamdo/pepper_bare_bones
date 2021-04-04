/*
    describes the IA-32 architecture’s task management facilities.
     These facilities are only available when the processor is running in protected mode.
*/

#define KERNEL__Vir_MM
#define KERNEL__PAGE_MM
#include <i386types.h>
#include <init/video.h>
#include <kernel/mm.h>
#include <stddef.h>
#include <kernel/task.h>

sheduler_t sheduler;

static task_control_block_t main_task, task1, task2 , task3;

void task1_()
{
    kprintf(2, 14, "task 1\n");

    while (1)
        ;
}

void task3_()
{
	kprintf(2, 14, "task 3\n");

    while (1)
        ;
}

void task2_()
{
    kprintf(2, 14, "task 2\n");

    while (1)
        ;
}
void __switch()
{
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;

    sheduler.running_task = sheduler.running_task->new_tasks;

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
}

void init_multitasking()
{
    // Get EFLAGS and cr3

    asm volatile(
        "movl %%cr3, %%eax;"
        "movl %%eax, %0;"
        : "=m"(main_task.regs.cr3)::"%eax");

    asm volatile(
        "pushfl;"
        "pop %%eax;"
        "movl %%eax , %0;"
        : "=m"(main_task.regs.eflags)::"%eax");

    create_task(&task1, task1_, main_task.regs.eflags, main_task.regs.cr3);
    create_task(&task2, task2_, main_task.regs.eflags, main_task.regs.cr3);
    create_task(&task3, task3_, main_task.regs.eflags, main_task.regs.cr3);

    kprintf(2, 15, "[K:CPU]\tInit sheduling\n");

    main_task.new_tasks = &task1;
    task1.new_tasks = &task2;
    task2.new_tasks = &task3;
    task3.new_tasks = &main_task;

    sheduler.running_task = &main_task;
    sheduler.init_timer = 0;
    sheduler.task_timer = DELAY_PER_TASK;
}

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    task->regs.eax = 0;
    task->regs.ebx = 0;
    task->regs.ecx = 0;
    task->regs.edx = 0;
    task->regs.esi = 0;
    task->regs.edi = 0;

    task->regs.eflags = eflags;
    task->regs.eip = (uint32_t)task_func;
    task->regs.cr3 = (uint32_t)cr3;
    task->regs.esp = (uint32_t)kmalloc(200);
    task->new_tasks = 0;
}
