# pepper_bare_bones


*Kernel from scratch for intel core 32 bits*

My goal is to make OS that will use for performance networking research and engineering.


For now, we are still at the initialisation steps, ... :

- Simples boot sectors (First stage and second stage)
- Apic and IOAPIC
- Pagination and segmentation functionnality
- Memory Allocation
- Process management
- I/O management
- Kernel console and monitor for execute some instructions


**Why is OS kernel for performance networking research design/implementation hard/interesting?
  * the environment is unforgiving: quirky h/w, weak debugger
  * it must be efficient (thus low-level?)
  ...but abstract/portable (thus high-level?)
  * powerful (thus many features?)
  ...but simple (thus a few composable building blocks?)
  * features interact: fd = open(); ...; fork()
  * behaviors interact: CPU priority vs memory allocator
  * open problems: security; performance; exploiting new hardware

**We implement operating systems kernel if we...
  * want to work on the above problems
  * care about what's going on under the hood
  * have to find high-performance systems
  * need to diagnose bugs or security problems
