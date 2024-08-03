.altmacro

@---------------------------------------- expression
.macro .MyOutWrn expression
  .warning	".MyOutWrn: \expression"
.endm
.macro .MyOutErr expression
  .error 	  ".MyOutErr: \expression"
.endm
.macro .MyOutPrn expression
  .print	  ".MyOutPrn: \expression"
.endm

/* using:
#define RCC_BASE (AHBPERIPH_BASE + 0x00001000UL)
x = 555
.MyOutPrn %x            @ .MyOutPrn: 555
.MyOutPrn %x+5          @ .MyOutPrn: 560
.MyOutPrn _RCC_BASE     @ .MyOutPrn: _RCC_BASE (просто изменили имя, теперь это undefined (если), поэтому строка)
.MyOutPrn %RCC_BASE     @ .MyOutPrn: 1073876992
.MyOutPrn RCC_BASE      @ .MyOutPrn: ((0x40000000UL+0x00020000UL)+0x00001000UL)
*/

@---------------------------------------- string
.macro .MyOutStr string
  .print    string
.endm
/* using:
.MyOutStr "Hello World!!" @ Hello World! (если нужен !, то ставь !!)
*/


@---------------------------------------- _name, defination, value
.macro .MyOutDefAux _name, defination, value
  .print ".MyOutDef: _name = defination = value"
.endm
.macro .MyOutDef _name, defination:vararg
  .MyOutDefAux _name, defination, %defination
.endm
/* using:
.MyOutDef _RCC_BASE, RCC_BASE   @ .MyOutDef: _RCC_BASE = ((0x40000000UL+0x00020000UL)+0x00001000UL) = 1073876992
*/






@----------------------------------------

.macro .MyLbl x,y
    x&y&_label:
.endm
@ using:.MyLbl One, Two   ->   OneTwo_label:

@----------------------------------------

/*
#====C (работало, теперь чет не работает (может работало на arm-toolchain, а сейчас - st)):
#====definition to expand macro then apply to pragma message====
#define VALUE_TO_STRING(X) #X
#define VALUE(X) VALUE_TO_STRING(X)
#define VAR_NAME_VALUE(var) #var "="  VALUE(var)
#using: #define VAR 9876543210
#using: #pragma message "Message is " VALUE(VAR)
#using: #pragma message (VAR_NAME_VALUE(VAR))
*/
