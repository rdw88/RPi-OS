ARMGNU ?= arm-none-eabi

BUILD = build/
SOURCE = src/
COPS = -Wall -O0 -nostdlib -nostartfiles -ffreestanding
OBJECTS = $(patsubst $(SOURCE)%.c, $(BUILD)%.o, $(wildcard $(SOURCE)*.c))


gcc : kernel.img

clean :
	rm -f $(BUILD)*


$(BUILD)vectors.o : $(SOURCE)vectors.s $(BUILD)
	$(ARMGNU)-as $(SOURCE)vectors.s -o $@

$(BUILD)%.o : $(SOURCE)%.c $(BUILD)
	$(ARMGNU)-gcc $(COPS) -c $< -o $@


kernel.img : loader $(BUILD)vectors.o $(OBJECTS)
	$(ARMGNU)-ld $^ -T loader -o $(BUILD)kernel.elf
	$(ARMGNU)-objdump -D $(BUILD)kernel.elf > $(BUILD)kernel.list
	$(ARMGNU)-objcopy $(BUILD)kernel.elf -O ihex $(BUILD)kernel.hex
	$(ARMGNU)-objcopy $(BUILD)kernel.elf -O binary $(BUILD)kernel.img
