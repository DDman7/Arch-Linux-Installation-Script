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

exit
