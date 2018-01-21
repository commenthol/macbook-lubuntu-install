#!/bin/bash

export DISK=/dev/sda
export MNT=/media/lubuntu/GRUB2EFI

# ---- 

CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
export BOOT=$MNT/EFI/BOOT

mkdir -p $BOOT
mkdir -p $MNT/boot/grub
mkdir -p $MNT/iso

sudo apt install grub-efi-amd64-bin grub-efi-ia32-bin

MOD=fat iso9660 part_gpt part_msdos memdisk \
	normal boot linux linuxefi linux16 configfile loopback chain \
	efifwsetup efi_gop efi_uga \
	ls lsefi lsacpi lspci search search_label search_fs_uuid search_fs_file \
	gfxterm gfxterm_background gfxterm_menu test all_video loadenv \
	exfat ext2 ntfs btrfs hfsplus udf

rm $BOOT/boot*.efi
grub-mkimage -o $BOOT/bootx64.efi -p /efi/boot -O x86_64-efi $MOD
grub-mkimage -o $BOOT/bootia32.efi -p /efi/boot -O i386-efi $MOD
ls -al $BOOT

#sudo grub-install --removable --boot-directory=$MNT/boot --efi-directory=$BOOT $DISK

cp $CWD/grub.cfg $BOOT/grub.cfg
cp $CWD/post.sh $MNT
