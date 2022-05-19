echo -e "Welcome to installer\n"

pacman -Sy
iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm archlinux-keyring #update keyrings to latest to prevent packages failing to install
pacman -S --noconfirm --needed pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacman -S --noconfirm --needed reflector rsync grub git
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo -ne "
-------------------------------------------------------------------------
                    Setting up $iso mirrors for faster downloads
-------------------------------------------------------------------------
"
reflector -a 48 -c IN -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt &>/dev/null # Hiding error message if any


echo -e "Did you create and format partitions?? Say YES if you did\n"
read CreateFormat
if [ "$CreateFormat" != "YES" ]
	then
		echo -e "Create and Format partitions before proceeding!!"
		exit -1
fi

umount -A --recursive /mnt # make sure everything is unmounted before we start

mount /dev/vda2 /mnt
mkdir -pv /mnt/boot
mkdir -pv /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi
mkdir -pv /mnt/home
mount /dev/vda3 /mnt/home

echo -ne "
-------------------------------------------------------------------------
                    Arch Install on Main Drive
-------------------------------------------------------------------------
"
pacstrap /mnt base nano archlinux-keyring wget --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

genfstab -L /mnt >> /mnt/etc/fstab
echo " 
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

git clone https://github.com/SisyphusIsntHappy/Arch.git
cp -rp Arch /mnt/Arch
sed -i -e 's/\r$//' /mnt/Arch/*.sh

arch-chroot /mnt
