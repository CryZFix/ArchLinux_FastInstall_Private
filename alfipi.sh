#!/bin/bash
mkdir ~/downloads
cd ~/downloads

localectl --no-convert set-x11-keymap us,ru "" "" grp:alt_shift_toggle

echo 'Установка AUR (pikaur)'
sudo pacman -R reflector --noconfirm
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Syy wget git curl --needed base base-devel --noconfirm
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/pikaur.tar.gz'
tar xzfv pikaur*
cd pikaur
makepkg -fsri --noconfirm

echo 'Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo 'Установка базовых программ и пакетов'
sudo pacman -S ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

echo 'Установить рекомендумые программы?'
pikaur -S recoll google-chrome flameshot veracrypt vlc vim freemind icq-bin anydesk-bin libreoffice libreoffice-fresh-ru neofetch qbittorrent galculator --noconfirm
pikaur -Syy
pikaur -S xflux hunspell-ru pamac-aur-git megasync-nopdfium trello xorg-xkill ttf-symbola ttf-clear-sans nomachine --noconfirm
sudo pacman -Rs xfburn orage parole mousepad xfce4-appfinder xfce4-clipman-plugin xfce4-timer-plugin xfce4-time-out-plugin xfce4-artwork xfce4-taskmanager xfce4-smartbookmark-plugin xfce4-sensors-plugin xfce4-notes-plugin xfce4-netload-plugin xfce4-dplugin xfce4-mpc-plugin xfce4-mount-plugin xfce4-mailwatch-plugin xfce4-genmon-plugin xfce4-fsguard-plugin xfce4-eyes-pluiskperf-plugin xfce4-dict xfce4-cpugraph-plugin xfce4-cpufreq-plugin

echo 'Делаем авто вход без DE?'
read -p "1 - Да, 0 - Нет: " node_set
if [[ $node_set == 1 ]]; then
sudo systemctl disable sddm
sudo pacman -R sddm --noconfirm
sudo pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xserverrc ~/.xserverrc
wget https://raw.githubusercontent.com/ordanax/arch/master/attach/.xinitrc
sudo mv -f .xinitrc ~/.xinitrc
wget https://raw.githubusercontent.com/ordanax/arch/master/attach/.bashrc
rm ~/.bashrc
sudo mv -f .bashrc ~/.bashrc
read -p "Введите имя пользователя: " username
sudo echo -e '[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin' "$username" '--noclear %I $TERM' > ~/downloads/override.conf
sudo mkdir /etc/systemd/system/getty@tty1.service.d/
sudo mv -f ~/downloads/override.conf /etc/systemd/system/getty@tty1.service.d/override.conf
elif [[ $node_set == 0 ]]; then
  echo 'Пропускаем.'
fi

# Подключаем zRam
pikaur -S zramswap --noconfirm
sudo systemctl enable zramswap.service

echo 'Включаем сетевой экран'
sudo ufw enable

echo 'Добавляем в автозагрузку:'
sudo systemctl enable ufw

# Очистка
rm -rf ~/downloads/

echo 'Установка завершена!'