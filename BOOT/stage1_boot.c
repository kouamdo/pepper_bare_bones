extern void read_sectors(), call_second_boot();

short bootdrive;

int err = 0; // contain 1 if error

void __simple_print_boot__(char* msg)
{
    int i = 0;

    while (msg[i] != '\0') {
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
        ++i;
    }
}

void main_boot(void)
{
    read_sectors();

    if (err == 1)
        __simple_print_boot__("Bad boot device\n");

    else
        call_second_boot();
end:
    goto end;
}
