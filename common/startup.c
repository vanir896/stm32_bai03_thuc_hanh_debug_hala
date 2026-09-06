#include <stdint.h>
extern uint32_t _sidata, _sdata, _edata, _sbss, _ebss, _estack;
int main(void);
void Default_Handler(void) { while (1) {} }
void HardFault_Handler(void) { while (1) {} }
void Reset_Handler(void) {
    uint32_t *src = &_sidata, *dst = &_sdata;
    while (dst < &_edata) { *dst++ = *src++; }
    for (dst = &_sbss; dst < &_ebss; ) { *dst++ = 0u; }
    (void)main();
    while (1) {}
}
typedef void (*isr_t)(void);
__attribute__((section(".isr_vector"), used))
const isr_t g_vectors[16] = {
    (isr_t)&_estack, Reset_Handler, Default_Handler, HardFault_Handler,
    Default_Handler, Default_Handler, Default_Handler, 0,
    0, 0, 0, Default_Handler, Default_Handler, 0, Default_Handler, Default_Handler
};
