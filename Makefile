PREFIX ?= arm-none-eabi-
CC := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
SIZE := $(PREFIX)size
COMMON := common
TARGET := lesson
CFLAGS := -mcpu=cortex-m3 -mthumb -std=c11 -ffreestanding -fdata-sections -ffunction-sections -Wall -Wextra -Og -g3
LDFLAGS := -nostdlib -Wl,--gc-sections -Wl,-T,$(COMMON)/linker.ld -Wl,-Map,$(TARGET).map

all: $(TARGET).elf $(TARGET).bin

$(TARGET).elf: main.c $(COMMON)/startup.c $(COMMON)/linker.ld
	$(CC) $(CFLAGS) main.c $(COMMON)/startup.c $(LDFLAGS) -o $@
	$(SIZE) $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).map
