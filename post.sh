#!/bin/bash

disk=sda
efi=${disk}1
linux=${disk}3

case $1 in
  mount)
    sudo mount /dev/$linux /mnt
    sudo mount /dev/$efi /mnt/boot/efi
    for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
    sudo chroot /mnt
    ;;
  install)
    grub-install /dev/$disk
    update-grub
    ;;
  umount)
    for i in /dev /dev/pts /proc /sys /run; do sudo umount /mnt$i; done
    ;;
  *)
    cat "$0"
    ;;
esac

