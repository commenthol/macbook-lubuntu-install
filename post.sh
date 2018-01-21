#!/bin/bash

disk=sda
# we assume that EFI Partition is the 1st one
efi=${disk}1
# the linux partition follows osx
linux=${disk}3

# ---- 

function _mount () {
  echo ... mounting volumes
  sudo mount /dev/$linux /mnt
  sudo mount /dev/$efi /mnt/boot/efi
  for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
}
function _umount () {
  echo ... unmounting volumes
  for i in /dev /dev/pts /proc /sys /run; do sudo umount /mnt$i; done
  sudo umount /mnt/boot/efi
  sudo umount /mnt
}
function _grub () {
  echo ... update grub installer on /dev/$linux
  grub-install /dev/$linux
  update-grub
}
function _efipackages () {
  echo ... need network connection to update efi packages
  apt update
  # install 32/64bit efi and let the installer decide
  apt install grub-efi-ia32-bin grub-efi-amd64-bin
}

case $1 in
  install)
    _mount
    sudo cp $0 /mnt
    sudo chmod a+x /mnt/post.sh
    echo ... chroot to installation to install missing packs and grub
    sudo chroot /mnt /post.sh grub
    sudo rm /mnt/post.sh
    _umount
    ;;
  mount)
    _mount
    ;;
  grub)
    _efipackages
    _grub
    ;;
  umount)
    _umount
    ;;
  *)
    cat "$0"
    ;;
esac

