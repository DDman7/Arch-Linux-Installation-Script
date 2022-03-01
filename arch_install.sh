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

mkfs.fat -F32 /dev/vda1 && mkfs.ext4 /dev/vda2 # Create file systems for each partition

pacman -Syy # Sync the pacman repo

pacman -S reflector --noconfirm # Download and install the reflector tool
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak # Create a backup of the default mirror list
reflector -c "AU" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist # Use the best mirror I guess?

mount /dev/vda2 /mnt # Mount the root partition to /mnt
pacstrap /mnt base linux linux-firmware nano # Download and install the specified software packages to the root partition mounted at /mnt
genfstab -U /mnt >> /mnt/etc/fstab # Generate an fstab file to define how disk partitions, block devices or remote file systems are mounted into the system.

arch-chroot /mnt # Change root to the specified directory
