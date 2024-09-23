#make -j4 all
#STM32F0

SRC		= Core/Src
INC		= Core/Inc#dirs separated by space
BLD		= Debug

DEF 	= DEBUG#RELEASE|DEBUG
SUF		= .elf
LDSCRIPT= $(wildcard $(SRC)/*.ld)
FLG 	= -g#debug

OBJ1	= $(wildcard $(SRC)/*.s $(SRC)/*.c)
OBJ2	= $(notdir $(basename $(OBJ1)))
OBJ		= $(addprefix $(BLD)/, $(addsuffix .o, $(OBJ2)))

TGT		= $(BLD)/$(notdir $(basename $(CURDIR)))$(SUF)

CC 		= arm-none-eabi-gcc
AS 		= arm-none-eabi-gcc
LD 		= arm-none-eabi-gcc

CPPFLAGS= -std=gnu11 -mcpu=cortex-m0 -mthumb -Wall -Wextra# --specs=nano.specs -mfloat-abi=soft -ffunction-sections -fdata-sections
CFLAGS 	= $(CPPFLAGS) -c $(FLG) $(addprefix -I,$(INC)) $(addprefix -D,$(DEF)) -MMD
ASFLAGS	= $(CFLAGS) -x assembler-with-cpp -Wa,-adlms=$(BLD)/$*.lst -Wa,--MD=$(BLD)/$*.as.d
LDFLAGS	= -nostdlib -T$(LDSCRIPT) -Wl,-Map=%,--cref# -static -Wl,--gc-sections,--start-group -lc -lm -Wl,--end-group -lnosys $(CPPFLAGS)

.PHONY: all install clean

all:$(TGT)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = all"

$(TGT): $(OBJ)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = LD ($<)"
	$(LD) $(LDFLAGS) -o $@ $^

$(BLD)/%.o: $(SRC)/%.s | $(BLD)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = AS ($<)"
	$(AS) $(ASFLAGS) -o $@ $<
	@-sed -i 's/\/tmp\/.*.s//' $(BLD)/$*.as.d

$(BLD)/%.o: $(SRC)/%.c | $(BLD)
	@echo "= = = = = = = = = = = = = = = = = = = = = = = = = CC ($<)"
	$(CC) $(CFLAGS) -o $@ $<

$(BLD):
	@mkdir -p $@

-include $(wildcard $(BLD)/*.d)

clean:
	@-rm -fR $(BLD)

install: all
	openocd -f board/st_nucleo_f0.cfg -c "program $(TGT) verify reset exit"
