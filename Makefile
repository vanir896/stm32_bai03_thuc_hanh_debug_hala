PREFIX ?= arm-none-eabi-
CC := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
SIZE := $(PREFIX)size
COMMON := common
TARGET := lesson

CFLAGS := -mcpu=cortex-m3 -mthumb -std=c11 -ffreestanding \
          -fdata-sections -ffunction-sections -Wall -Wextra -Og -g3 \
          -MMD -MP -I. -I$(COMMON)

LDFLAGS := -nostdlib -Wl,-T,$(COMMON)/linker.ld -Wl,-Map,$(TARGET).map

# Danh sách mã nguồn
SRCS := main.c $(COMMON)/startup.c

# Tự động sinh danh sách file .o và .d
OBJS := $(SRCS:.c=.o)
DEPS := $(OBJS:.o=.d)

all: $(TARGET).elf $(TARGET).bin

# Giai đoạn 1: Biên dịch từng file .c thành file .o (tự sinh file .d tương ứng)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Giai đoạn 2: Link các file .o thành .elf
$(TARGET).elf: $(OBJS) $(COMMON)/linker.ld
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).map $(OBJS) $(DEPS)

-include $(DEPS)