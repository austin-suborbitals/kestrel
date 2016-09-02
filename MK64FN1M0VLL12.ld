/*
 * NXP Kinetis MK64FN1M0VLL12
 */


ENTRY(init)
OUTPUT_ARCH(arm)

MEMORY {
    /*
     * flash storage section
     */
    VECTORS         (rx)  : ORIGIN = 0x00000000, LENGTH = 0x400                 /* 1024 bytes of ISR table */
    FLASH           (rx)  : ORIGIN = 0x00000400, LENGTH = 0x100000 - 0x400      /* 1 MiB, minus the vectors */


    /*
     * low SRAM bank (64KiB)
     */
    STACK           (rw)  : ORIGIN = 0x1FFF8000, LENGTH = 0x8000                /* stack - 32 KiB */

    /*
     * high SRAM bank (192KiB)
     */
    RAM             (rwx) : ORIGIN = 0x20000000, LENGTH = 0x30000
}


SECTIONS
{
    /*
     * interrrupt vector table
     */
    .interrupts : {
        __vectors_begin = .;
        KEEP(*(.interrupt_table))
        __vectors_end = .;
    } > VECTORS



    /*
     * code section.
     */
    .text : {
        . = ALIGN(4);
        __text_begin = .;

        *(.text*)

        *(.rodata*)
        *(.eh_frame*)

        __text_end = .;
    } > FLASH


    /*
     * the stack grows towards the heap/RAM, and away from code.
     * this setup should help to eliminate hard faults if we overrun the stack
     */
    .stack (NOLOAD): {
        . = ALIGN(4);           /* align stack on a word boundary */
        __stack_begin = .;
        . += LENGTH(STACK);
        __stack_end = .;
    } > STACK


    /*
     * the bss section will be nulled as one of the first boot steps
     */
    .bss (NOLOAD): {
        . = ALIGN(0x4);
        __bss_begin = .;

        *(.bss*)

        __bss_end = .;
    } > RAM


    /*
     * pre-initialized data section
     */
    .data : {
        . = ALIGN(0x4);
        __data_begin = .;
        *(.data*)
        __data_end = .;
    } >RAM AT>FLASH

    /*
     * use all remaining RAM for the heap
     */
    .heap : {
        . = ALIGN(0x4);             /* align heap to a word aligned address */
        __heap_begin = .;
        /* all remaining RAM is used for the heap */
        . += LENGTH(RAM) - (__data_end - __data_begin) - (__bss_end - __bss_begin);
        __heap_end = .;
    } >RAM


    /DISCARD/ :
    {
        *(.glue_7*)         /* arm-thumb interworking */
        *(.v4_bx)           /* ARMv4 interworking fixup for missing BX */
        *(.vfp11_veneer)    /* VFP11 bugfixes s.a. http://sourceware.org/ml/binutils/2006-12/msg00196.html */
        *(.iplt .igot.plt)  /* STT_GNU_IFUNC symbols */
        *(.rel.*)           /* dynamic relocations */
        *(.ARM.exidx*)      /* index entries for section unwinding */
        *(.ARM.extab*)      /* exception unwinding information */
        *(.debug*)          /* TODO: lots of .debug_str */
    }
}
