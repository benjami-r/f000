/* ******************************************************************************
** My linker script for NUCLEO-F072RB Board (STM32F072RBTx, stm32f0 series)
** 		128KBytes FLASH
** 		16KBytes RAM
** Set heap size, stack size and stack location.
****************************************************************************** */

ENTRY(Reset_Handler) /* Entry Point */

_estack = ORIGIN(RAM) + LENGTH(RAM); /* Highest address of the user mode stack - end of "RAM" */

_Min_Heap_Size = 0x200; /* required amount of heap */
_Min_Stack_Size = 0x400; /* required amount of stack */

MEMORY
{
  RAM     (xrw)    : ORIGIN = 0x20000000,   LENGTH =  16K
  FLASH    (rx)    : ORIGIN = 0x08000000,   LENGTH = 128K
}

SECTIONS
{
  /* :::::::::::::::::::: VMA : >FLASH :::::::::::::::::::: */
  .isr_vector :           /* ::::: The startup code into "FLASH" Rom */
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector))  /* Startup code */
    . = ALIGN(4);
  } >FLASH

  .text :                 /* ::::: The program code and other data into "FLASH" Rom */
  {
    . = ALIGN(4);
    *(.text)              /* .text sections (code) */
    *(.text*)             /* .text* sections (code) */
    . = ALIGN(4);
    _etext = .;           /* define a global symbols at end of code */
  } >FLASH

  /*  */
  .rodata :               /* ::::: Constant data into "FLASH" Rom */
  {
    . = ALIGN(4);
    *(.rodata)            /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)           /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  /* :::::::::::::::::::: VMA : >RAM AT> FLASH :::::::::::::::::::: */
  _sidata = LOADADDR(.data); /* Used by the startup to initialize data */

  .data :                 /* ::::: Initialized data sections into "RAM" Ram */
  {
    . = ALIGN(4);
    _sdata = .;           /* create a global symbol at data start */
    *(.data)              /* .data sections */
    *(.data*)             /* .data* sections */
    . = ALIGN(4);
    _edata = .;           /* define a global symbol at data end */
  } >RAM AT> FLASH

  /* :::::::::::::::::::: VMA : >RAM :::::::::::::::::::: */
  . = ALIGN(4);           /* ::::: Uninitialized data section into "RAM" Ram */
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    _sbss = .;            /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)            /* см. директиву .lcomm */
    . = ALIGN(4);
    _ebss = .;            /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  ._user_heap_stack :     /* ::::: User_heap_stack section, used to check enough "RAM" Ram left */
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM


}

