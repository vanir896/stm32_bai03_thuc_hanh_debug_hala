#include <stdint.h>

typedef void (*isr_handler_t)(void);

extern uint32_t _estack;
extern uint32_t _sidata;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

int main(void);
void Reset_Handler(void);
void Default_Handler(void);

__attribute__((section(".isr_vector"), used))
const uintptr_t vector_table[] = {
    (uintptr_t)&_estack,
    (uintptr_t)Reset_Handler,
};

static void runtime_copy_data(void)
{
    const uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;
    while (dst < &_edata) {
        *dst++ = *src++;
    }
}

static void runtime_clear_bss(void)
{
    uint32_t *dst = &_sbss;
    while (dst < &_ebss) {
        *dst++ = 0U;
    }
}

void Reset_Handler(void)
{
    runtime_copy_data();
    runtime_clear_bss();

    (void)main();
    for (;;) {
    }
}

void Default_Handler(void)
{
    for (;;) {
    }
}