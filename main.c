#include <stdint.h>

volatile uint32_t initialized_value = 0x12345678U;
volatile uint32_t zero_value;
volatile uint32_t zero_buffer[4];

int main(void)
{
    for (;;) {
        asm volatile ("nop");
    }
}