# pepper_bare_bones


Kernel from scratch for intel core 32 bits
My goal is to make OS that will use in networking and telecommunications research and engineering.


For now, we are still at the initialisation steps, ... 

Aptitudes: 
- Simples boot sectors (First stage and second stage)
- Apic and IOAPIC
- Pagination and segmentation functionnality
- Memory Allocation
- Process management
- I/O management

* Why is O/S for telecommunications research design/implementation hard/interesting?
  * the environment is unforgiving: quirky h/w, weak debugger
  * it must be efficient (thus low-level?)
  ...but abstract/portable (thus high-level?)
  * powerful (thus many features?)
  ...but simple (thus a few composable building blocks?)
  * features interact: fd = open(); ...; fork()
  * behaviors interact: CPU priority vs memory allocator
  * open problems: security; performance; exploiting new hardware
