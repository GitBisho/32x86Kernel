/* Bare Bones OSDEV */

/* Constants for the multiboot header */
.set ALIGN,     1<<0            /* Aligns loaded modules on page boundaries */
.set MEMINFO,   1<<1            /* Memory map */
.set FLAGS,     ALIGN | MEMINFO /* Multiboot flag field */
.set MAGIC,     0x1BADB002      /* enables bootloader to find header */
.set CHECKSUM, -(MAGIC + FLAGS) /* proves we are multiboot */

/* Marks the program as a kernel. The bootloader searches for this signature in the first 8KiB of the kernel file. */
.section .multiboot
.align 4 /* Boundary for signature in bytes */
.long MAGIC
.long FLAGS
.long CHECKSUM

/* Here we declare the stack and alocate some memory, putting a symbol at the bottom. "The stack is in its own section so it can be marked nobits,
which means the kernel file is smaller because it does not contain an uninitialized stack." The compiler assumes our stack is properly aligned,
so if it is not, undefined behavior will occur */
.section .bss       /* "The block starting symbol is the portion of an object file, executable, or assembly language code that contains statically allocated 
                    variables that are declared but have not been assigned a value yet." */
.align 16           /* According to the System V ABI standard */
stack_bottom:
.skip 16384         /* 16 KiB stack */
stack_top:          

/* No need to return because the bootloader is gone */

.section .text
.global _start /* entry point */
.type _start, @function
_start: 
        /*
	    "The bootloader has loaded us into 32-bit protected mode on a x86
	    machine. Interrupts are disabled. Paging is disabled. The processor
	    state is as defined in the multiboot standard. The kernel has full
	    control of the CPU. The kernel can only make use of hardware features
	    and any code it provides as part of itself. There's no printf
	    function, unless the kernel provides its own <stdio.h> header and a
	    printf implementation. There are no security restrictions, no
	    safeguards, no debugging mechanisms, only what the kernel provides
	    itself. It has absolute and complete power over the
	    machine."
	    */
        mov $stack_top, %esp /* Stacks grow downward on x86, so we set to the top */

        call kernel_main /* needs to be called at 16 byte alignments; since we have intialized nothing on the stack, we can do this */

        cli
1:      hlt
        jmp 1b /* Puts the computer in a loop: disables interrupts with cli, waits for the next one with hlt, then we jump to the next hlt if it ever wakes up */


/* size of _start = current location - _start. Useful for debugging or call tracing */
.size _start, . - _start