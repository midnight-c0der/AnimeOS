#!/bin/sh
CFLAGS="-I/usr/include/efi \
-I/usr/include/efi/x86_64 \
-I/usr/include/efi/protocol \
-fno-stack-protector \
-fpic \
-fshort-wchar \
-mno-red-zone \
-DHAVE_USE_MS_ABI"

#Compile bootloader
clang -I efi -I common -target x86_64-pc-win32-coff -fno-builtin -ffreestanding -fno-stack-protector -fshort-wchar -mno-red-zone -c boot/boot.c
lld-link -subsystem:efi_application -nodefaultlib -dll -entry:efi_main boot.o -out:BOOTX64.efi

#Compile kernel
clang -I efi -I common -I kernel -I kernel/text_renderer -I kernel/lib -I kernel/memory_manager -I kernel/gdt -ffreestanding -fno-stack-protector -nostdlib -fuse-ld=lld -static -T kernel/kernel.lds \
				-Wall -Wextra -Werror -Wmissing-field-initializers -Wuninitialized \
				kernel/kernel.cpp \
				kernel/text_renderer/text_renderer.cpp \
				kernel/text_renderer/font.cpp \
				kernel/lib/memory.cpp \
				kernel/lib/math.cpp \
				kernel/utils.cpp \
				kernel/memory_manager/pmm.cpp \
				kernel/memory_manager/vmm.cpp \
				kernel/gdt/gdt.cpp \
				kernel/gdt/gdt.s \
				-o kernel.elf
