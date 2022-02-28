#!/bin/bash

timedatectl set-ntp true # Set time and date

(
echo o # Create a new empty DOS partition table
echo n # Create a new partition
echo p # Primary partition
echo 1 # Partiton number
echo   # First sector (Accept default: 1)
echo +512M # 512MB partition size
echo n # Add a new partition
echo p # Primary partition
echo 2 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | fdisk /dev/vda # Pipe all those inputs into fdisk for the appropriate device

mkfs.fat -F 32 /dev/vda1 && mkfs.ext4 /dev/vda2 # Create file systems for each partition

mount /dev/vda2 /mnt # Mount the root partition to /mnt
mkdir /mnt/boot # Create the appropriate directory to mount the EFI partition to
mount /dev/vda1 /mnt/boot # Mount the EFI partition to the newly-created directory

pacstrap /mnt base linux linux-firmware networkmanager # Download and install the specified software packages to the root partition mounted at /mnt

genfstab -U /mnt >> /mnt/etc/fstab # No idea

arch-chroot /mnt # Change root to the specified directory

ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime # Set the time zone

hwclock --systohc # To generate /etc/adjtime

locale-gen # Generate locales

touch /etc/locale.conf # Create the locale.conf file
echo "LANG=en_US.UTF-8" >> /etc/locale.conf # Append the specified text to the specified file.

(
echo 1999
echo 1999
) | passwd # Setting the root user password

pacman -S grub efibootmgr # Downloading and installing the boot loader

grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot # Install the grub boot loader
grub-mkconfig -o /boot/grub/grub.cfg # Create the grub config file
