#include <stdint.h>
#include "math_ops.h"
#include "config.h"

volatile uint32_t result_word;
volatile uint32_t magic_word = APP_MAGIC_VALUE;
uint8_t work_buffer[256];

int main(void)
{
    result_word = add3(1U, 2U, 3U);
    for (;;) {
        __asm volatile ("nop");
    }
}