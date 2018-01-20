#!/bin/bash

disk=sda
efi=${disk}1
linux=${disk}3

function _extract () {
  # extract missing files
  sudo tar xf /isodevice/grub-i386-pc.txz -C /mnt
}
function _mount () {
  sudo mount /dev/$linux /mnt
  sudo mount /dev/$efi /mnt/boot/efi
  for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
}
function _umount () {
  for i in /dev /dev/pts /proc /sys /run; do sudo umount /mnt$i; done
  sudo umount /mnt/boot/efi
  sudo umount /mnt
}
function _grub () {
  grub-install /dev/$disk
  update-grub
}

case $1 in
  install)
    _mount
    _extract
    sudo cp $0 /mnt
    sudo chmod a+x /mnt/post.sh
    sudo chroot /mnt /post.sh grub
    sudo rm /mnt/post.sh
    _umount
    ;;
  mount)
    _mount
    ;;
  grub)
    _grub
    ;;
  umount)
    _umount
    ;;
  *)
    cat "$0"
    ;;
esac

