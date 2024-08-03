#make -j4 all
#STM32F0

DEF		:= STM32F072xB#separated by space

D_SRC		:= Core/Src
D_INC		:= Core/Inc#separated by space
D_OUT		:= Debug

OBJECTS		:= $(patsubst $(D_SRC)/%.c,$(D_OUT)/%.o,$(wildcard $(D_SRC)/*.c)) \
		   $(patsubst $(D_SRC)/%.s,$(D_OUT)/%.o,$(wildcard $(D_SRC)/*.s)) \
		   $(patsubst $(D_SRC)/%.S,$(D_OUT)/%.o,$(wildcard $(D_SRC)/*.S))

TARGET		:= $(D_OUT)/$(notdir $(basename $(CURDIR))).elf
GCC		:= arm-none-eabi-gcc -std=gnu11 -mcpu=cortex-m0 -mthumb -Wall -Wextra# --specs=nano.specs -mfloat-abi=soft -ffunction-sections -fdata-sections -MMD
CC 		:= $(GCC) $(addprefix -I,$(D_INC)) -c#$(addprefix -D,$(DEF)) -MMD
CC 		+= -g#debug
AS 		:= $(CC) -x assembler-with-cpp
LDSCRIPT	:= $(wildcard $(D_SRC)/*.ld)
LD 		:= $(GCC) -nostdlib -T$(LDSCRIPT) -Wl,-Map=%,--cref# -nostdlib -static -Wl,-Map=%,--cref,--gc-sections#,--start-group -lc -lm -Wl,--end-group# -lnosys
OBJCOPY	:= arm-none-eabi-objcopy

all: $(TARGET)

$(TARGET): $(OBJECTS) | $(D_OUT) Makefile $(LDSCRIPT)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = ld ($^)"
	@$(LD) -o $@ $^
	@$(OBJCOPY) -O binary $@ $@.bin

$(D_OUT)/%.o: $(D_SRC)/%.s Makefile | $(D_OUT)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = as ($<)"
	@$(AS) -Wa,-adlms=$(D_OUT)/$*.lst -Wa,--MD=$(D_OUT)/$*.D -o $@ $< #-adlms=$(D_OUT)/$*.lst
	@-sed -i 's/\/tmp\/.*.s//' $(D_OUT)/$*.D

$(D_OUT)/%.o: $(D_SRC)/%.S Makefile | $(D_OUT)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = as ($<)"
	@$(AS) -Wa,-adlms=$(D_OUT)/$*.lst -Wa,--MD=$(D_OUT)/$*.D -o $@ $< #-adlms=$(D_OUT)/$*.lst
	@-sed -i 's/\/tmp\/.*.s//' $(D_OUT)/$*.D

$(D_OUT)/%.o: $(D_SRC)/%.c Makefile | $(D_OUT)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = cc ($<)"
	@$(CC) -o $@ $<

-include $(wildcard $(D_OUT)/*.D)#лепит чушь из as-компил-теки "tmp", исправляем sed-ами

$(D_OUT):
	@mkdir -p $@

clean:
	@-rm -fR $(D_OUT)

program: all
	openocd -f board/st_nucleo_f0.cfg -c "program $(TARGET) verify reset exit"

.PHONY: all clean program
