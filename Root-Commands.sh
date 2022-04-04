#!/usr/bin/env bash

#opens KDialog progress window
dbusRef=`kdialog --title "Installing, please wait" --progressbar "Starting..." 17`
qdbus-qt5 $dbusRef showCancelButton false

qdbus-qt5 $dbusRef Set "" value 1
qdbus-qt5 $dbusRef setLabelText "Adding Packman Repository..."
#adds packman repo
zypper --non-interactive --quiet addrepo --refresh -p 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ 'packman'
zypper --gpg-auto-import-keys refresh
zypper --non-interactive dist-upgrade --allow-vendor-change --from packman

qdbus-qt5 $dbusRef Set "" value 2
qdbus-qt5 $dbusRef setLabelText "Installing Media Codecs..."
#installs codecs from packman
zypper --non-interactive install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

qdbus-qt5 $dbusRef Set "" value 3
qdbus-qt5 $dbusRef setLabelText "Installing Microsoft Fonts (takes some time)..."
#installs Microsoft fonts
zypper --non-interactive install -y fetchmsttfonts

qdbus-qt5 $dbusRef Set "" value 4
qdbus-qt5 $dbusRef setLabelText "Installing Build Tools..."
#installs build essentials
zypper --non-interactive install -y patterns-devel-base-devel_basis

qdbus-qt5 $dbusRef Set "" value 5
qdbus-qt5 $dbusRef setLabelText "Installing CUPS..."
#installs cups
zypper --non-interactive install -y cups
groupadd lpadmin
usermod -a -G lpadmin $USER
sed -i "s/^SystemGroup root.*/SystemGroup lpadmin/" /etc/cups/cups-files.conf

qdbus-qt5 $dbusRef Set "" value 6
qdbus-qt5 $dbusRef setLabelText "Installing 7-Zip..."
#installs 7zip
zypper --non-interactive install -y 7zip

qdbus-qt5 $dbusRef Set "" value 7
qdbus-qt5 $dbusRef setLabelText "Disabeling Boot Delay..."
#disables boot timeout
sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

qdbus-qt5 $dbusRef Set "" value 8
qdbus-qt5 $dbusRef setLabelText "Setting up Firewall..."
#sets firewall zone to trusted
sed -i "s/^DefaultZone=public.*/DefaultZone=trusted/" /etc/firewalld/firewalld.conf
systemctl restart firewalld

qdbus-qt5 $dbusRef Set "" value 9
qdbus-qt5 $dbusRef setLabelText "Disabling Boot Messages..."
#hides acpi errors and white line
if ! grep -Fxq "loglevel" "/etc/default/grub" ; then
  sudo sed -i 's/quiet/& loglevel=3/' /etc/default/grub
fi
if ! grep -Fxq "vt.global_cursor_default" "/etc/default/grub" ; then
  sudo sed -i 's/loglevel=3/& vt.global_cursor_default=0/' /etc/default/grub
fi
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

qdbus-qt5 $dbusRef Set "" value 10
qdbus-qt5 $dbusRef setLabelText "Decreasing Swappiness..."
#decreases swappiness
if ! grep -Fxq "vm.swappiness" "/etc/sysctl.conf" ; then
  echo "vm.swappiness=10" >> /etc/sysctl.conf
fi

qdbus-qt5 $dbusRef Set "" value 11
qdbus-qt5 $dbusRef setLabelText "Enabling autounlock for KWallet..."
#auto unlocks KWallet
zypper --non-interactive install -y pam_kwallet

qdbus-qt5 $dbusRef Set "" value 12
qdbus-qt5 $dbusRef setLabelText "Installing Gnome Keyring..."
#installs and auto unlocks Gnome-Keyring
zypper --non-interactive install -y gnome-keyring seahorse
if ! grep -Fxq "pam_gnome_keyring.so" "/etc/pam.d/sddm" ; then
  sed -i "/common-auth/a auth	optional	pam_gnome_keyring.so" /etc/pam.d/sddm
  sed -i "/common-session/a session	optional	pam_gnome_keyring.so auto_start" /etc/pam.d/sddm
fi

qdbus-qt5 $dbusRef Set "" value 13
qdbus-qt5 $dbusRef setLabelText "Installing Snap..."
#installs snap
zypper --non-interactive addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
zypper --gpg-auto-import-keys refresh
zypper --non-interactive dist-upgrade --from snappy
zypper --non-interactive install snapd
systemctl enable --now snapd
systemctl enable --now snapd.apparmor

qdbus-qt5 $dbusRef Set "" value 14
qdbus-qt5 $dbusRef setLabelText "Installing Flatpak..."
#installs flatpak
zypper --non-interactive install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

qdbus-qt5 $dbusRef Set "" value 15
qdbus-qt5 $dbusRef setLabelText "Allowing vendor change..."
#allows vendor change
sudo sed -i 's/.*solver.allowVendorChange.*/solver.allowVendorChange = true/' /etc/zypp/zypp.conf

qdbus-qt5 $dbusRef Set "" value 16
qdbus-qt5 $dbusRef setLabelText "Updating System..."
#installs updates
#removes and locks YaST Online Update module
zypper --non-interactive remove -y yast2-online-update yast2-online-update-frontend
zypper addlock yast2-online-update yast2-online-update-frontend

qdbus-qt5 $dbusRef Set "" value 17
qdbus-qt5 $dbusRef setLabelText "Updating System..."
#installs updates
zypper --non-interactive refresh
zypper --non-interactive dist-upgrade --allow-vendor-change

#closes KDialog progress window
qdbus-qt5 $dbusRef close

#closes the script
exit
