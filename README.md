# Lubuntu install on white Macbook

This tutorial aims to install a Lubuntu 17.10 on a Macbook3,1 using live CD via usb-stick.
My major problem was running the desktop 32bit ISO which does not fit on a CD. This may also work on an old MacMini1,1

## requisites

- VM Host http://virtualbox.org
- Live Lubuntu ISO Image
- USB-Stick >= 2GB

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

Still in Live-CD...

1. Download the `grub.sh`, `grub.cfg` together with `post.sh` script in same folder.
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
  │       ├── bootia32.efi
  │       └── grub.cfg
  ├── iso
  │   └── lubuntu-17.10.1-desktop-i386.iso
  └── post.sh
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
7. Boot into Live CD - this may take some time... make credit to USB1

## install Lubuntu

1. Click on "Install Lubuntu 17.10"
   - You may check <https://help.ubuntu.com/community/Lubuntu/InstallingLubuntu> on howto install
   - Do **NOT** unmount partitions that are in use (it's your usb-stick we need for installation)
2. Run the partiioning using your second partition you peviously created under OSX.
   - Note down the device name lubuntu gets installed. E.g. `/dev/sda3`
   - Run the installer - it will stop with an error stating that grub can`t be installed
   - Do **NOT shutdown** the computer.
3. Grub bootloader installation using `post.sh` script.
   - Check your partitions first with `sudo fdisk -l /dev/sda`
   - Make sure your Linux filesystem is at `/dev/sda3`. If this is not the case edit `post.sh` and change the line `linux=${disk}3` accordingly. Use `cp /isodevice/post.sh .`
   - Run `sh /isodevice/post.sh install`

## postinstall

- Install additional drivers...
  - Broadcom Wifi
  - Intel Microcode
- You may change the default behavior for function keys
  - See details https://help.ubuntu.com/community/AppleKeyboard
  - TLTR
    ```bash
    echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
    sudo update-initramfs -u -k all
    ```
- isight http://bersace03.free.fr/ift/
  ```bash
  sudo apt install isight-firmware-tools
  # mount Macintosh HD from file manager
  sudo ift-extract -a /media/$USER/Macintosh\ HD/System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext/Contents/MacOS/AppleUSBVideoSupport
  ```
- There is an issue with [drm:drm_atomic_helper_commit_cleanup_done [drm_kms_helper]] *ERROR* [CRTC:26:pipe A] flip_done timed out in `dmesg`
  - check https://bbs.archlinux.org/viewtopic.php?pid=1689914#p1689914
  - in `/etc/default/grub` add
    ```bash
    GRUB_CMDLINE_LINUX_DEFAULT="acpi_osi=Linux acpi_backlight=vendor video=SVIDEO-1:d"
    ```
    then run `update-grub`

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
