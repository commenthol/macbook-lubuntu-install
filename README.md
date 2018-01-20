# Lubuntu install on old Macbook2

This tutorial aims to install a Lubuntu 17.10 on a Macbook2 using live CD via usb-stick.
My major problem was running the desktop 32bit ISO which does not fit on a CD. This may also work on an old Mac-Mini...

## requisites

- VM Host http://virtualbox.org
- Live Lubuntu ISO Image
- USB-Stick ~ 2GB

## start live CD

1. Download Live CD - I'm using [Lubuntu 17.10][Lubuntu 17.10].
2. Start VirtualBox and create new VM mounting ISO-Image
3. Start Live-CD VM
   - For Lubuntu 17.10 it might be necessary to start with "nomodeset" option
     Press "F6" Other Options and set "nomodeset"

## format usb-stick

In Live-CD open terminal wit `ctrl + alt + t`

1. `sudo gparted`
2. Select USB-Drive (e.g. /dev/sda)
3. Menu:Device > Create Partition Table > Dialog:Warning This will ERASE... > Dropdown:gpt > Button:Apply
4. Menu:Partition > New > Filesystem: Dropdown:fat32 ; Partition Name: GRUB2EFI > OK > Menu:Edit > Apply all Operations
5. Exit `gparted`

## prepare grub efi

1. Download the `grub.sh` together with `grub.cfg` script.
2. Make sure that your usb-stick is device `/dev/sda` and mounted under `/media/lubuntu/GRUB2EFI`.
   - If this is not the case edit the `grub.sh` script.
3. Run `sh grub.sh` from the terminal.
4. If using a different ISO-Image you may need to change grub.cfg in `EFI/BOOT` folder on the usb-stick.
5. Switch to your Host-OS and copy the iso image to the `/iso` folder

  Your stick should contain these files now.
  ````
  /media/lubuntu/GRUB2EFI
  ├── EFI
  │   └── BOOT
  │       ├── bootx64.efi
  │       └── grub.cfg
  ├── grub-i386-pc.txz
  └── iso
      └── lubuntu-17.10.1-desktop-i386.iso
  ````

## macbook2 prepare

1. Boot into OSX and open "Disk Utility"
2. Repartition your Harddisk to decrease your OSX Partition. Create a new one for Lubuntu
   - Check here on how to do <http://www.peachpit.com/articles/article.aspx?p=1395749>
3. Download ReFind <https://sourceforge.net/projects/refind/files/0.11.2/refind-bin-0.11.2.zip/download>
   - Unzip and run `./refind-install`
   - Documentation is at <http://www.rodsbooks.com/refind/installing.html#osx>
4. Shutdown OSX
5. Insert usb-stick in macbook and boot holding the `alt` key.
6. Select the "EFI Boot" with USB-Icon (right-most)
7. Boot into Live CD - this may take some time...

## install Lubuntu

1. Click on "Install Lubuntu 17.10"
   - You may check <https://help.ubuntu.com/community/Lubuntu/InstallingLubuntu> on howto install
   - Do **NOT** unmount partitions that are in use (it's your usb-stick we need for installation)
2. Run the partiioning using your second partition you peviously created under OSX.
   - Note down the device name lubuntu gets installed. E.g. `/dev/sda3`
   - Run the installer - it will stop with an error stating that grub can`t be installed
   - Do **NOT shutdown** the computer.
3. Download the `post.sh` script.
   - Check your partitions first with `sudo fdisk -l /dev/sda`
   - Make sure your Linux filesystem is at `/dev/sda3`. If this is not the case open `post.sh` and change the line `linux=${disk}3` accordingly.
   - Run `sh post.sh mount` to mount your partitions
   - Then `sh post.sh install` to reinstall grub
   - Exit with `exit`
   - Then run `sh post.sh unmount` and reboot.

## License

- Content is licensed under [CC0](http://creativecommons.org/publicdomain/zero/1.0/).
- Source code is licensed under [Unlicense](http://unlicense.org/)

## References

- http://lubuntu.org/
- https://askubuntu.com/questions/395879/how-to-create-uefi-only-bootable-usb-live-media
- https://ubuntuforums.org/showthread.php?t=2276498
- https://help.ubuntu.com/community/UEFIBooting#Building_GRUB2_.28U.29EFI
- http://howtoubuntu.org/how-to-repair-restore-reinstall-grub-2-with-a-ubuntu-live-cd
- [ReFind][ReFind]

[Lubuntu 17.10]: http://cdimage.ubuntu.com/lubuntu/releases/17.10.1/release/lubuntu-17.10.1-desktop-i386.iso
[ReFind]: http://www.rodsbooks.com/refind
