/*
* file      STM32F072RBT6.INC.s
* author    SAL
* library   st:DS9826:28
            st:RM0091:52
*
*        _ORIGIN    - first address (bottom) (name same in map.ld)
*        _BOUND    - last address + 1 (top boundary, first address after area, not inclusive)
*
*
*/

// - - - - - - Common
SETBIT_0                        = 1<<0              // 0000 0000 0000 0000  0000 0000 0000 0001
SETBIT_1                        = 1<<1              // 0000 0000 0000 0000  0000 0000 0000 0010
SETBIT_2                        = 1<<2              // 0000 0000 0000 0000  0000 0000 0000 0100
SETBIT_3                        = 1<<3              // 0000 0000 0000 0000  0000 0000 0000 1000
SETBIT_4                        = 1<<4              // 0000 0000 0000 0000  0000 0000 0001 0000
SETBIT_5                        = 1<<5              // 0000 0000 0000 0000  0000 0000 0010 0000
SETBIT_6                        = 1<<6              // 0000 0000 0000 0000  0000 0000 0100 0000
SETBIT_7                        = 1<<7              // 0000 0000 0000 0000  0000 0000 1000 0000
SETBIT_8                        = 1<<8              // 0000 0000 0000 0000  0000 0001 0000 0000
SETBIT_9                        = 1<<9              // 0000 0000 0000 0000  0000 0010 0000 0000
SETBIT_10                       = 1<<10             // 0000 0000 0000 0000  0000 0100 0000 0000
SETBIT_11                       = 1<<11             // 0000 0000 0000 0000  0000 1000 0000 0000
SETBIT_12                       = 1<<12             // 0000 0000 0000 0000  0001 0000 0000 0000
SETBIT_13                       = 1<<13             // 0000 0000 0000 0000  0010 0000 0000 0000
SETBIT_14                       = 1<<14             // 0000 0000 0000 0000  0100 0000 0000 0000
SETBIT_15                       = 1<<15             // 0000 0000 0000 0000  1000 0000 0000 0000
SETBIT_16                       = 1<<16             // 0000 0000 0000 0001  0000 0000 0000 0000
SETBIT_17                       = 1<<17             // 0000 0000 0000 0010  0000 0000 0000 0000
SETBIT_18                       = 1<<18             // 0000 0000 0000 0100  0000 0000 0000 0000
SETBIT_19                       = 1<<19             // 0000 0000 0000 1000  0000 0000 0000 0000
SETBIT_20                       = 1<<20             // 0000 0000 0001 0000  0000 0000 0000 0000
SETBIT_21                       = 1<<21             // 0000 0000 0010 0000  0000 0000 0000 0000
SETBIT_22                       = 1<<22             // 0000 0000 0100 0000  0000 0000 0000 0000
SETBIT_23                       = 1<<23             // 0000 0000 1000 0000  0000 0000 0000 0000
SETBIT_24                       = 1<<24             // 0000 0001 0000 0000  0000 0000 0000 0000
SETBIT_25                       = 1<<25             // 0000 0010 0000 0000  0000 0000 0000 0000
SETBIT_26                       = 1<<26             // 0000 0100 0000 0000  0000 0000 0000 0000
SETBIT_27                       = 1<<27             // 0000 1000 0000 0000  0000 0000 0000 0000
SETBIT_28                       = 1<<28             // 0001 0000 0000 0000  0000 0000 0000 0000
SETBIT_29                       = 1<<29             // 0010 0000 0000 0000  0000 0000 0000 0000
SETBIT_30                       = 1<<30             // 0100 0000 0000 0000  0000 0000 0000 0000
SETBIT_31                       = 1<<31             // 1000 0000 0000 0000  0000 0000 0000 0000

TRUE                            = 1
FALSE                           = 0
SETON                           = TRUE
SETOFF                          = FALSE

KB                              = 1024
MB                              = KB*KB
GB                              = MB*KB

// - - - - - - Memory REGIONs
REGION7_PPB                     = 0xE0000000        // 0.5Gb - Private Peripheral Bus (PPB)
REGION6_EP2                     = 0xC0000000        // 0.5Gb - External peripherals-2
REGION5_EP1                     = 0xA0000000        // 0.5Gb - External peripherals-1
REGION4_ER2                     = 0x80000000        // 0.5Gb - External RAM-2
REGION3_ER1                     = 0x60000000        // 0.5Gb - External RAM-1
REGION2_PER                     = 0x40000000        // 0.5Gb - (Internal) Peripherals
REGION1_RAM                     = 0x20000000        // 0.5Gb - (Internal) RAM
REGION0_ROM                     = 0x00000000        // 0.5Gb - (Internal) FLASH

// - - - - - - MEMORY-part has equivalent data with "STM32F072RBT6_map.ld"
SRAM_ORIGIN                     = REGION1_RAM + 0x00000000
SRAM_LENGTH                     = 16*KB
SRAM_BOUND                      = SRAM_ORIGIN + SRAM_LENGTH
FLASH_ORIGIN                    = REGION0_ROM + 0x08000000
FLASH_LENGTH                    = 128*KB
FLASH_BOUND                     = FLASH_ORIGIN + FLASH_LENGTH

// - - - - - - (Internal) Peripherals in REGION2_PER (st:RM0091:48 base)
PER_AHB2                        = REGION2_PER + 0x08000000
PER_AHB1                        = REGION2_PER + 0x00020000
PER_APB                         = REGION2_PER + 0x00000000

// - - - - - - GPIOx in PER_AHB2
AHB2_GPIOF                      = PER_AHB2 + 0x00001400     // 1KB
AHB2_GPIOE                      = PER_AHB2 + 0x00001000     // 1KB
AHB2_GPIOD                      = PER_AHB2 + 0x00000C00     // 1KB
AHB2_GPIOC                      = PER_AHB2 + 0x00000800     // 1KB
AHB2_GPIOB                      = PER_AHB2 + 0x00000400     // 1KB
AHB2_GPIOA                      = PER_AHB2 + 0x00000000     // 1KB

// - - - - - - Groups in PER_AHB1
AHB1_TSC                        = PER_AHB1 + 0x00024000     // 1KB
AHB1_CRC                        = PER_AHB1 + 0x00023000     // 1KB
AHB1_FMI                        = PER_AHB1 + 0x00022000     // 1KB - Flash memory interface
AHB1_RCC                        = PER_AHB1 + 0x00001000     // 1KB - RCC registers
AHB1_DMA                        = PER_AHB1 + 0x00000000     // 1KB - DMA registers

// - - - - - - Registers of group AHB1_RCC
RCC_CR                          = AHB1_RCC + 0x00           // Clock control register (RCC_CR), RM0091:110
RCC_CFGR                        = AHB1_RCC + 0x04           // Clock configuration register (RCC_CFGR)
RCC_CIR                         = AHB1_RCC + 0x08           // Clock interrupt register (RCC_CIR)
RCC_APB2RSTR                    = AHB1_RCC + 0x0C           // APB peripheral reset register 2 (RCC_APB2RSTR)
RCC_APB1RSTR                    = AHB1_RCC + 0x10           // APB peripheral reset register 1 (RCC_APB1RSTR)
RCC_AHBENR                      = AHB1_RCC + 0x14           // AHB peripheral clock enable register (RCC_AHBENR), Reset value: 0x0000 0014
RCC_APB2ENR                     = AHB1_RCC + 0x18           // APB peripheral clock enable register 2 (RCC_APB2ENR)
RCC_APB1ENR                     = AHB1_RCC + 0x1C           // APB peripheral clock enable register 1 (RCC_APB1ENR)
RCC_BDCR                        = AHB1_RCC + 0x20           // RTC domain control register (RCC_BDCR)
RCC_CSR                         = AHB1_RCC + 0x24           // Control/status register (RCC_CSR)
RCC_AHBRSTR                     = AHB1_RCC + 0x28           // AHB peripheral reset register (RCC_AHBRSTR)
RCC_CFGR2                       = AHB1_RCC + 0x2C           // Clock configuration register 2 (RCC_CFGR2)
RCC_CFGR3                       = AHB1_RCC + 0x30           // Clock configuration register 3 (RCC_CFGR3)
RCC_CR2                         = AHB1_RCC + 0x34           // Clock control register 2 (RCC_CR2)

// - - - - - - Values of register RCC_AHBENR
AHBENR_TSCEN_24                 = SETBIT_24         // Touch sensing controller clock enable
AHBENR_IOPFEN_22                = SETBIT_22         // I/O port F clock enable
AHBENR_IOPEEN_21                = SETBIT_21         // I/O port E clock enable
AHBENR_IOPDEN_20                = SETBIT_20         // I/O port D clock enable
AHBENR_IOPCEN_19                = SETBIT_19         // I/O port C clock enable
AHBENR_IOPBEN_18                = SETBIT_18         // I/O port B clock enable
AHBENR_IOPAEN_17                = SETBIT_17         // I/O port A clock enable
AHBENR_CRCEN_6                  = SETBIT_6          // CRC clock enable
AHBENR_FLITFEN_4                = SETBIT_4          // FLITF clock enable
AHBENR_SRAMEN_2                 = SETBIT_2          // SRAM interface clock enable
AHBENR_DMA2EN_1                 = SETBIT_1          // DMA2 clock enable
AHBENR_DMAEN_0                  = SETBIT_0          // DMA clock enable
AHBENR_RESET_VALUE              = AHBENR_FLITFEN_4 + AHBENR_SRAMEN_2    // Reset value: 0x0000 0014

// - - - - - - Registers of group AHB2_GPIOx(x=A..F) (Registers of A-port has specific reset value!!!)
GPIOx_MODER                     = 0x00          // Bits 31:0MODER[15:0][1:0]: Port x configuration I/O pin y (y = 15 to 0): 00: Input mode (reset state), 01: General purpose output mode, 10: Alternate function mode, 11: Analog mode
GPIOx_OTYPER                    = 0x04          // Bits 31:16 Reserved, Bits 15:0 OT[15:0]: Port x configuration I/O pin y (y = 15 to 0): 0: Output push-pull (reset state), 1: Output open-drain
GPIOx_OSPEEDR                   = 0x08          // Bits 31:0OSPEEDR[15:0][1:0]: Port x configuration I/O pin y (y = 15 to 0): x0: Low speed, 01: Medium speed, 11: High speed
GPIOx_PUPDR                     = 0x0C          // Bits 31:0 PUPDR[15:0][1:0]: Port x configuration I/O pin y (y = 15 to 0): 00: No pull-up, pull-down, 01: Pull-up, 10: Pull-down, 11: Reserved
GPIOx_IDR                       = 0x10          // Bits 31:16 Reserved, Bits 15:0 IDR[15:0]: Port x input data I/O pin y (y = 15 to 0). These bits are read-only.
GPIOx_ODR                       = 0x14          // Bits 31:16 Reserved, Bits 15:0 ODR[15:0]: Port output data I/O pin y (y = 15 to 0)
GPIOx_BSRR                      = 0x18          // Bits 31:16BR[15:0]: Port x reset I/O pin y (y = 15 to 0). These bits are write-only.: 0: No action, 1: Resets the corresponding ODRx bit. Note: If both BSx and BRx are set, BSx has priority. Bits 15:0BS[15:0]: Port x set I/O pin y (y = 15 to 0). These bits are write-only. A read to these bits returns the value 0x0000. 0: No action, 1: Sets the corresponding ODRx bit
GPIOx_LCKR                      = 0x1C          // ...
GPIOx_AFRL                      = 0x20          // ...
GPIOx_AFRH                      = 0x24          // ...
GPIOx_BRR                       = 0x28          // ???




/* - - - - - - - - - - - - - - - - - - - - - - - - */

