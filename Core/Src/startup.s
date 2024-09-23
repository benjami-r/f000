.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

.include "My_common.mac.s"
#include "My_core_cm0.h"
#include "My_stm32f072xb.h"



@= = = = = = = = = = = = = = = = = = = = = = = = = .section .text.Reset_Handler
.section .text.Reset_Handler
.type Reset_Handler, %function
.global Reset_Handler
Reset_Handler:
	mov   r0, r0
 	mov   r0, r0
	nop
	nop
	ldr r0, =_version		@ My pastime

DoGPIOA_On:	@ Включаем тактирование устройства GPIOA:
	.MyOutDef _RCC_BASE, RCC_BASE
	ldr r0, =(RCC_BASE + 0x14)		@ адрес AHBENR: RCC (0x40021000) + смещ. 0x14
	ldr r1, [r0]					@ загружаем текущее значение AHBENR
	.MyOutDef _RCC_AHBENR_GPIOAEN, RCC_AHBENR_GPIOAEN
	ldr r2, =(RCC_AHBENR_GPIOAEN)	@ маска бита включения GPIOAEN (0x1UL << 17U)
	orrs r1, r2						@ накладываем маску на текущее значение AHBENR
	str r1, [r0]					@ сохраняем новое значение AHBENR (GPIOA тактирован)
DoPA5_Output_mode:
	.MyOutDef _GPIOA_BASE, GPIOA_BASE
	ldr r0, =(GPIOA_BASE + 0x00)	@ адрес MODER: GPIOA (0x48000000) + смещ. 0x00
	ldr r1, [r0]					@ загружаем текущее значение MODER
	.MyOutDef _GPIO_MODER_MODER5, GPIO_MODER_MODER5
	ldr r2, =(GPIO_MODER_MODER5)	@ маска MODER5 (0x3UL << 10U)
	bics r1, r2						@ чистим поле MODER5 НЕ-маской MODER5
	ldr r2, =(GPIO_MODER_MODER5_0)	@ маска бита MODER5_0 (т.е. значение "01: General purpose output mode" для поля MODER5)
	orrs r1, r2						@ накладываем маску на текущее значение MODER
	str r1, [r0]					@ сохраняем новое значение MODER (PA5 в General purpose output mode)
									@ остальные конфигурационные трогать для наших целей вродь не надо

@Если будем делать функцию конфигурации, можно предусмотреть параметры, способные принимать значения сразу для нескольких пинов - PA5 | PA6, ведь ей все равно сколько пинов настраивать за один проход. То же касается включения тактирования одного или нескольких GPIOx.

DoPA5_set: @ Включаем/выключаем LD2 установкой/сбросом единицы на PA5 путем записи нужного бита в BSRR:
	.MyOutDef _GPIO_BSRR_BS_5, GPIO_BSRR_BS_5
	ldr r0, =(GPIOA_BASE + 0x18)	@ адрес BSRR: GPIOA (0x48000000) + смещ. 0x18
	ldr r1, =(GPIO_BSRR_BS_5)		@ маска BS_5 (1 для 5-го пина -  5й бит, =0x20)
	ldr r2, =(GPIO_BSRR_BR_5)		@ маска BR_5 (1 для 5-го пина - 21й бит, =0x200000)
DoLD2_setOn:
@	str r1, [r0]

DoLD2_setOff:
@	str r2, [r0]

@--------------
	ldr r3, =(SysTick_BASE + 0x0c)			@ адрес STK_CALIB
	ldr r5, [r3]

	DELAY = 500000 @ 500000=~0.5 sec
	@ 1. Программируйте значение SYST_RVR:RELOAD.
	ldr r3, =(SysTick_BASE + 0x04)			@ адрес STK_RVR
@	ldr r5, =(SysTick_LOAD_RELOAD_Msk)		@ пользуем маску как макс. значение RELOAD (в "core_cm0.h" тоже так делают)
	ldr r5, =(DELAY)
	str r5, [r3]
movs r5,0
ldr r5, [r3]
	@ 2. Очистите значение SYST_CVR:CURRENT (актом записи неважно чего в SYST_CVR).
	ldr r3, =(SysTick_BASE + 0x08)			@ адрес STK_CVR
	movs r5, 0
	str r5, [r3]
movs r5,0
ldr r5, [r3]
	@ 4. Программируйте регистр управления и состоянияS TK_CSR
	ldr r3, =(SysTick_BASE + 0x00)			@ адрес STK_CSR
	ldr r5, [r3]							@ берем текущее значение STK_CSR
@	ldr r6, =(SysTick_CTRL_CLKSOURCE_Msk | SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk) @ включаем тактирование, прерывания и запускаем счетчик
ldr r6, =( SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk)
	orrs r5, r6								@ накладываем на текущее значение STK_CSR
	movs r4,0								@ флаг: лэд выключен
	str r5, [r3]							@ сохраняем новое значение STK_CSR. Запустили.
movs r5,0
	ldr r5, [r3]



@прерывание на кнопку (нажал - горит)
@прерывание на таймер (нажал - мигает)


@	bkpt
@	mov   sp, r0          /* set stack pointer */
@	bl main

@----------------------------------------
LoopForever:
	b LoopForever




.size Reset_Handler, .-Reset_Handler

@= = = = = = = = = = = = = = = = = = = = = = = = = .section .text.Default_Handler
.section .text.Default_Handler
.type Default_Handler, %function
.global Default_Handler
Default_Handler:
Infinite_Loop:
	b Infinite_Loop
.size Default_Handler, .-Default_Handler

.section .text.SysTick_Handler
.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
	cmp r4, 0	@ лэд выключен?
	bne 1f		@ нет (включен) - идем выключать
0:				@ да (выключен) - включаем:
	str r1, [r0]
	movs r4, 1	@ подняли флажок
	b 2f
1:				@ включен - выключаем:
	str r2, [r0]
	movs r4, 0	@ опустили флажок
2:
	BX LR
.size SysTick_Handler, .-SysTick_Handler

@= = = = = = = = = = = = = = = = = = = = = = = = = .section .isr_vector
.section .isr_vector,"a",%progbits
.type g_pfnVectors, %object
g_pfnVectors:
.word  _estack
.word  Reset_Handler
.word  NMI_Handler
.word  HardFault_Handler
.word  0
.word  0
.word  0
.word  0
.word  0
.word  0
.word  0
.word  SVC_Handler
.word  0
.word  0
.word  PendSV_Handler
.word  SysTick_Handler
.word  WWDG_IRQHandler                   /* Window WatchDog              */
.word  PVD_VDDIO2_IRQHandler             /* PVD and VDDIO2 through EXTI Line detect */
.word  RTC_IRQHandler                    /* RTC through the EXTI line    */
.word  FLASH_IRQHandler                  /* FLASH                        */
.word  RCC_CRS_IRQHandler                /* RCC and CRS                  */
.word  EXTI0_1_IRQHandler                /* EXTI Line 0 and 1            */
.word  EXTI2_3_IRQHandler                /* EXTI Line 2 and 3            */
.word  EXTI4_15_IRQHandler               /* EXTI Line 4 to 15            */
.word  TSC_IRQHandler                    /* TSC                          */
.word  DMA1_Channel1_IRQHandler          /* DMA1 Channel 1               */
.word  DMA1_Channel2_3_IRQHandler        /* DMA1 Channel 2 and Channel 3 */
.word  DMA1_Channel4_5_6_7_IRQHandler    /* DMA1 Channel 4, Channel 5, Channel 6 and Channel 7*/
.word  ADC1_COMP_IRQHandler              /* ADC1, COMP1 and COMP2         */
.word  TIM1_BRK_UP_TRG_COM_IRQHandler    /* TIM1 Break, Update, Trigger and Commutation */
.word  TIM1_CC_IRQHandler                /* TIM1 Capture Compare         */
.word  TIM2_IRQHandler                   /* TIM2                         */
.word  TIM3_IRQHandler                   /* TIM3                         */
.word  TIM6_DAC_IRQHandler               /* TIM6 and DAC                 */
.word  TIM7_IRQHandler                   /* TIM7                         */
.word  TIM14_IRQHandler                  /* TIM14                        */
.word  TIM15_IRQHandler                  /* TIM15                        */
.word  TIM16_IRQHandler                  /* TIM16                        */
.word  TIM17_IRQHandler                  /* TIM17                        */
.word  I2C1_IRQHandler                   /* I2C1                         */
.word  I2C2_IRQHandler                   /* I2C2                         */
.word  SPI1_IRQHandler                   /* SPI1                         */
.word  SPI2_IRQHandler                   /* SPI2                         */
.word  USART1_IRQHandler                 /* USART1                       */
.word  USART2_IRQHandler                 /* USART2                       */
.word  USART3_4_IRQHandler               /* USART3 and USART4            */
.word  CEC_CAN_IRQHandler                /* CEC and CAN                  */
.word  USB_IRQHandler                    /* USB                          */

.weak      NMI_Handler
.thumb_set NMI_Handler,Default_Handler
.weak      HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler
.weak      SVC_Handler
.thumb_set SVC_Handler,Default_Handler
.weak      PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler
@ .weak      SysTick_Handler
@ .thumb_set SysTick_Handler,Default_Handler
.weak      WWDG_IRQHandler
.thumb_set WWDG_IRQHandler,Default_Handler
.weak      PVD_VDDIO2_IRQHandler
.thumb_set PVD_VDDIO2_IRQHandler,Default_Handler
.weak      RTC_IRQHandler
.thumb_set RTC_IRQHandler,Default_Handler
.weak      FLASH_IRQHandler
.thumb_set FLASH_IRQHandler,Default_Handler
.weak      RCC_CRS_IRQHandler
.thumb_set RCC_CRS_IRQHandler,Default_Handler
.weak      EXTI0_1_IRQHandler
.thumb_set EXTI0_1_IRQHandler,Default_Handler
.weak      EXTI2_3_IRQHandler
.thumb_set EXTI2_3_IRQHandler,Default_Handler
.weak      EXTI4_15_IRQHandler
.thumb_set EXTI4_15_IRQHandler,Default_Handler
.weak      TSC_IRQHandler
.thumb_set TSC_IRQHandler,Default_Handler
.weak      DMA1_Channel1_IRQHandler
.thumb_set DMA1_Channel1_IRQHandler,Default_Handler
.weak      DMA1_Channel2_3_IRQHandler
.thumb_set DMA1_Channel2_3_IRQHandler,Default_Handler
.weak      DMA1_Channel4_5_6_7_IRQHandler
.thumb_set DMA1_Channel4_5_6_7_IRQHandler,Default_Handler
.weak      ADC1_COMP_IRQHandler
.thumb_set ADC1_COMP_IRQHandler,Default_Handler
.weak      TIM1_BRK_UP_TRG_COM_IRQHandler
.thumb_set TIM1_BRK_UP_TRG_COM_IRQHandler,Default_Handler
.weak      TIM1_CC_IRQHandler
.thumb_set TIM1_CC_IRQHandler,Default_Handler
.weak      TIM2_IRQHandler
.thumb_set TIM2_IRQHandler,Default_Handler
.weak      TIM3_IRQHandler
.thumb_set TIM3_IRQHandler,Default_Handler
.weak      TIM6_DAC_IRQHandler
.thumb_set TIM6_DAC_IRQHandler,Default_Handler
.weak      TIM7_IRQHandler
.thumb_set TIM7_IRQHandler,Default_Handler
.weak      TIM14_IRQHandler
.thumb_set TIM14_IRQHandler,Default_Handler
.weak      TIM15_IRQHandler
.thumb_set TIM15_IRQHandler,Default_Handler
.weak      TIM16_IRQHandler
.thumb_set TIM16_IRQHandler,Default_Handler
.weak      TIM17_IRQHandler
.thumb_set TIM17_IRQHandler,Default_Handler
.weak      I2C1_IRQHandler
.thumb_set I2C1_IRQHandler,Default_Handler
.weak      I2C2_IRQHandler
.thumb_set I2C2_IRQHandler,Default_Handler
.weak      SPI1_IRQHandler
.thumb_set SPI1_IRQHandler,Default_Handler
.weak      SPI2_IRQHandler
.thumb_set SPI2_IRQHandler,Default_Handler
.weak      USART1_IRQHandler
.thumb_set USART1_IRQHandler,Default_Handler
.weak      USART2_IRQHandler
.thumb_set USART2_IRQHandler,Default_Handler
.weak      USART3_4_IRQHandler
.thumb_set USART3_4_IRQHandler,Default_Handler
.weak      CEC_CAN_IRQHandler
.thumb_set CEC_CAN_IRQHandler,Default_Handler
.weak      USB_IRQHandler
.thumb_set USB_IRQHandler,Default_Handler

.size g_pfnVectors, .-g_pfnVectors
