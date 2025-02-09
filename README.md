OS dev project following advice from https://wiki.osdev.org/Expanded_Main_Page

Features:
Newline support
Basic scrolling

One of the most minimal kernels you could use.

To build:

Get an i386 gcc cross compiler and use that to compile your kernel and linker. Make sure your updated files are placed properly in the directory structure. You also need grub-mkrescue, which could require some hacking on Windows. 