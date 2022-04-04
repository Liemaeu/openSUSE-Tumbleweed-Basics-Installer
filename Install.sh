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

#installs cups
sudo zypper --non-interactive install -y cups
sudo groupadd lpadmin
sudo usermod -a -G lpadmin $USER
sudo sed -i "s/^SystemGroup root.*/SystemGroup lpadmin/" /etc/cups/cups-files.conf

#installs 7zip
sudo zypper --non-interactive install -y 7zip

#disables boot timeout
sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

#sets firewall zone to trusted
sudo sed -i "s/^DefaultZone=public.*/DefaultZone=trusted/" /etc/firewalld/firewalld.conf
sudo systemctl restart firewalld

#hides acpi errors and white line
if ! grep -Fxq "loglevel" "/etc/default/grub" ; then
  sudo sed -i 's/quiet/& loglevel=3/' /etc/default/grub
fi
if ! grep -Fxq "vt.global_cursor_default" "/etc/default/grub" ; then
  sudo sed -i 's/loglevel=3/& vt.global_cursor_default=0/' /etc/default/grub
fi
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

#decreases swappiness
if ! grep -Fxq "vm.swappiness" "/etc/sysctl.conf" ; then
  sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
fi

#auto unlocks KWallet
sudo zypper --non-interactive install -y pam_kwallet

#installs and auto unlocks Gnome-Keyring
sudo zypper --non-interactive install -y gnome-keyring seahorse
if ! grep -Fxq "pam_gnome_keyring.so" "/etc/pam.d/sddm" ; then
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
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#installs updates
sudo zypper --non-interactive refresh
sudo zypper --non-interactive dist-upgrade --allow-vendor-change

#sets YaST Software as default application for .rpm
if ! [ -f "$HOME/.config/mimeapps.list" ]; then
  echo "[Default Applications]" > $HOME/.config/mimeapps.list
fi
if ! grep -Fxq "application/x-rpm" "$HOME/.config/mimeapps.list" ; then
  sed -i "/Default Applications/a application/x-rpm=org.opensuse.yast.Packager.desktop;" $HOME/.config/mimeapps.list
fi

#removes Discover icon from the taskbar
if ! grep -Fxq "[Containments][2][Applets][5][Configuration][General]" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ; then
  echo "" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "[Containments][2][Applets][5][Configuration][General]" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "launchers=applications:systemsettings.desktop,preferred://filemanager,preferred://browser" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
fi

#sets search for updates to weekly
if ! grep -Fxq "[Containments][9][Applets][10][Configuration][General]" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ; then
  echo "" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "[Containments][9][Applets][10][Configuration][General]" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "daily=false" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "weekly=true" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
fi

#disables allow blocking of compositing
if ! grep -Fxq "WindowsBlockCompositing" "$HOME/.config/kwinrc" ; then
  sed -i "/Compositing/a WindowsBlockCompositing=false" $HOME/.config/kwinrc
fi

#allows vendor change
sudo sed -i 's/.*solver.allowVendorChange.*/solver.allowVendorChange = true/' /etc/zypp/zypp.conf

#sets up flatpak
flatpak update

exit
