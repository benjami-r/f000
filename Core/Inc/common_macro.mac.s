.altmacro

.macro .MyWrn e
  .warning "\e"       @ ".MyWrn=\e"
.endm
.macro .MyErr e
  .error "\e"         @ ".MyErr=\e"
.endm
.macro .MyPrn e
  .print "\e"         @ ".MyPrn=\e"
.endm
@ using:.set x, 555
@ using:.MyPrn %x   ->   555    // ".MyPrn=555"

.macro .MyLbl x,y
    x&y&_label:
.endm
@ using:.MyLbl One, Two   ->   OneTwo_label:
