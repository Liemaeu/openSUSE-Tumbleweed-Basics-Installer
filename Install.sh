#!/usr/bin/env bash

#Adds packman repo and installs codecs
sudo zypper --non-interactive --quiet addrepo --refresh -p 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ 'packman'
sudo zypper --gpg-auto-import-keys refresh
sudo zypper --non-interactive dist-upgrade --allow-vendor-change --from packman
sudo zypper --non-interactive install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

#disables boot timeout
sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

#auto unlocks KWallet
sudo zypper --non-interactive install -y pam_kwallet

#installs and auto unlocks Gnome-Keyring
sudo zypper --non-interactive install -y gnome-keyring seahorse
sudo sed -i "/common-auth/a auth	optional	pam_gnome_keyring.so" /etc/pam.d/sddm
sudo sed -i "/common-session/a session	optional	pam_gnome_keyring.so auto_start" /etc/pam.d/sddm

#installs updates
udo zypper --non-interactive refresh
sudo zypper --non-interactive dist-upgrade --allow-vendor-change

#sets YaST Software as default application for .rpm
if ! [ -f "$HOME/.config/mimeapps.list" ]; then
  echo "[Default Applications]" > $HOME/.config/mimeapps.list
fi
sed -i "/Default Applications/a application/x-rpm=org.opensuse.yast.Packager.desktop;" $HOME/.config/mimeapps.list
