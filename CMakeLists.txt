cmake_minimum_required(VERSION 3.20)
###################### CMAKE_TOOLCHAIN_FILE ###########################
# Specify toolchain. NOTE When building from inside STM32CubeIDE the location of the toolchain is resolved by the "MCU Toolchain" project setting (via PATH).  
set(CMAKE_SYSTEM_PROCESSOR "arm")
set(CMAKE_SYSTEM_NAME  "Generic") #mandatory
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY) #иначе не проходит какой-то тест (так понял, молча тест идет на executable, но не проходит линковка, а с library линковки нет)
set(CMAKE_C_COMPILER   "arm-none-eabi-gcc")
set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(CMAKE_AR           "arm-none-eabi-ar")
set(CMAKE_LINKER       "arm-none-eabi-ld")
set(CMAKE_OBJCOPY      "arm-none-eabi-objcopy")
set(CMAKE_RANLIB       "arm-none-eabi-ranlib")
set(CMAKE_SIZE         "arm-none-eabi-size")
set(CMAKE_STRIP        "arm-none-eabi-ld")
###################### VARIABLES ######################################
set(CMAKE_EXECUTABLE_SUFFIX           ".elf")
set(CMAKE_C_STANDARD                    "11")
set(CMAKE_C_FLAGS                       "-g")
set(CMAKE_ASM_FLAGS  "-x assembler-with-cpp")


project(
	f000 
	VERSION 0.0.0.1 
	DESCRIPTION MySTM32F0 
	HOMEPAGE_URL https://github.com/benjami-r/f000
	LANGUAGES C ASM
)
message("tHis is CMake ${PROJECT_NAME}")
include_directories(
	Core/Inc
)
add_compile_options(
	-std=gnu11
	-mcpu=cortex-m0
	-mthumb
	-Wall
	-Wextra
)
add_link_options(
	-nostdlib
	-T../Core/Src/STM32F072RBTX_My.ld
)
add_executable(
	${PROJECT_NAME}
	Core/Src/startup.s
	Core/Src/main.c
)

# $ cd f000
# $ make clean
# $ cmake -B Debug
# $ make -C Debug
# $ openocd -f board/st_nucleo_f0.cfg -c "program Debug/f000 verify reset exit"
