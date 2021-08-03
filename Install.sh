#!/usr/bin/env bash

#adds packman repo
sudo zypper --non-interactive --quiet addrepo --refresh -p 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ 'packman'
sudo zypper --gpg-auto-import-keys refresh
sudo zypper --non-interactive dist-upgrade --allow-vendor-change --from packman

#installs codecs from packman
sudo zypper --non-interactive install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

#installs Microsoft fonts
sudo zypper --non-interactive install -y fetchmsttfonts

#installs build essentials
sudo zypper --non-interactive install -y patterns-devel-base-devel_basis

#removes discover
sudo zypper --non-interactive remove -y discover

#disables boot timeout
sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

#decreases swappiness
if ! [ grep -Fxq "vm.swappiness" "/etc/sysctl.conf" ]; then
  sed -i "vm.swappiness=10" etc/sysctl.conf
fi

#auto unlocks KWallet
sudo zypper --non-interactive install -y pam_kwallet

#installs and auto unlocks Gnome-Keyring
sudo zypper --non-interactive install -y gnome-keyring seahorse
if ! [ grep -Fxq "pam_gnome_keyring.so" "/etc/pam.d/sddm" ]; then
  sudo sed -i "/common-auth/a auth	optional	pam_gnome_keyring.so" /etc/pam.d/sddm
  sudo sed -i "/common-session/a session	optional	pam_gnome_keyring.so auto_start" /etc/pam.d/sddm
fi

#installs snap
sudo zypper --non-interactive addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
sudo zypper --gpg-auto-import-keys refresh
sudo zypper --non-interactive dist-upgrade --from snappy
sudo zypper --non-interactive install snapd
sudo systemctl enable --now snapd
sudo systemctl enable --now snapd.apparmor

#installs flatpak
sudo zypper --non-interactive install -y flatpak

#installs updates
sudo zypper --non-interactive refresh
sudo zypper --non-interactive dist-upgrade --allow-vendor-change

#sets YaST Software as default application for .rpm
if ! [ -f "$HOME/.config/mimeapps.list" ]; then
  echo "[Default Applications]" > $HOME/.config/mimeapps.list
fi
if ! [ grep -Fxq "application/x-rpm=org.opensuse.yast.Packager.desktop" "$HOME/.config/mimeapps.list" ]; then
  sed -i "/Default Applications/a application/x-rpm=org.opensuse.yast.Packager.desktop;" $HOME/.config/mimeapps.list
fi

#sets up flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
