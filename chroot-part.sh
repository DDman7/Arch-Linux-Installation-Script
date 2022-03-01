#!/bin/bash

timedatectl set-timezone Australia/Sydney # Set the time zone

hwclock --systohc # To generate /etc/adjtime

locale-gen # Generate locales

touch /etc/locale.conf # Create the locale.conf file
echo "LANG=en_AU.UTF-8" >> /etc/locale.conf # Append the specified text to the specified file.
export LANG=en_AU.UTF-8

echo david-danyal > /etc/hostname # Set my network hostname
touch /etc/hosts # Create the hosts file

echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 david-danyal" >> /etc/hosts # Append something I don't understand to this file.

(
echo 1999
echo 1999
) | passwd # Setting the root user password

pacman -S --noconfirm grub efibootmgr # Downloading and installing the boot loader

mkdir /boot/efi # Create a directory to mount the EFI partition onto
mount /dev/vda1 /boot/efi # Mount the EFI partition to the specified directory

grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot # Install the grub boot loader
grub-mkconfig -o /boot/grub/grub.cfg # Create the grub config file

pacman -S --noconfirm xorg xfce4 xfce4-goodies lxdm # Download and install the xorg display server, the xfce4 desktop environment and the LXDM display manager

systemctl enable NetworkManager.service
systemctl start lxdm.service
systemctl enable lxdm.service


echo reboot | exit # Exit the chroot environment and reboot the system from the live ISO environment
