#!/bin/bash

timedatectl set-ntp true # Set time and date

(
echo n # Create a new partition
echo p # Primary partition
echo 1 # Partiton number
echo   # First sector (Accept default: 1)
echo +512M # 512MB partition size
echo t # Change the partition type
echo ef # Select the EFI partition type
echo n # Add a new partition
echo p # Primary partition
echo 2 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | fdisk /dev/vda # Pipe all those inputs into fdisk for the appropriate device

mkfs.fat -F32 /dev/vda1 # Create a fat32 file system for the EFI partition
mkfs.ext4 /dev/vda2 # Create an ext4 file system for the root partition

pacman -Syy # Sync the pacman repo
pacman -S --noconfirm reflector # Download and install the reflector tool
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak # Create a backup of the default mirror list
reflector -c "AU" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist # Use the best mirror I guess?

mount /dev/vda2 /mnt # Mount the root partition to /mnt
pacstrap /mnt base linux # Download and install the specified software packages to the root partition mounted at /mnt
genfstab -U /mnt >> /mnt/etc/fstab # Generate an fstab file to define how disk partitions, block devices or remote file systems are mounted into the system.

(
echo "timedatectl set-timezone Australia/Sydney" # Set the time zone
echo "hwclock --systohc" # To generate /etc/adjtime
echo "locale-gen" # Generate locales
echo "touch /etc/locale.conf" # Create the locale.conf file
echo "echo LANG=en_AU.UTF-8 >> /etc/locale.conf" # Append the specified text to the specified file.
echo "export LANG=en_AU.UTF-8" # No idea
echo "echo david-danyal > /etc/hostname" # Set my network hostname
echo -e "(\necho 1999\necho 1999\n) | passwd" #Setting the root user password
echo "pacman -S --noconfirm grub efibootmgr" # Downloading and installing the boot loader
echo "mkdir /boot/efi" # Create a directory to mount the EFI partition onto
echo "mount /dev/vda1 /boot/efi" # Mount the EFI partition to the specified directory
echo "grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi" # Install the grub boot loader
echo "grub-mkconfig -o /boot/grub/grub.cfg" # Create the grub config file
echo "pacman -S --noconfirm xorg" # Download and install the xorg display server
echo "pacman -S --noconfirm xfce4 xfce4-goodies lxdm networkmanager sudo nano" # Download and install extra software
echo "systemctl enable NetworkManager.service" # Enable the networkmanager service with systemd
echo "systemctl enable lxdm.service" # Enable the lxdm display manager service with systemd
echo "useradd -g users -G wheel,audio,video david-user" # Create a non-root user and add them to the specified groups
) | arch-chroot /mnt # Change root to the specified directory

shutdown now # Shut down the system after finishing with chroot
