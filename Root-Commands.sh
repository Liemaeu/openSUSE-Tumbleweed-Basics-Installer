#!/usr/bin/env bash

#opens KDialog progress window
dbusRef=`kdialog --title "Installing, please wait" --progressbar "Starting..." 12`
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
qdbus-qt5 $dbusRef setLabelText "Installing Microsoft Fonts..."
#installs Microsoft fonts
zypper --non-interactive install -y fetchmsttfonts

qdbus-qt5 $dbusRef Set "" value 4
qdbus-qt5 $dbusRef setLabelText "Installing Build Tools..."
#installs build essentials
zypper --non-interactive install -y patterns-devel-base-devel_basis

qdbus-qt5 $dbusRef Set "" value 5
qdbus-qt5 $dbusRef setLabelText "Removing Discover..."
#removes discover
zypper --non-interactive remove -y discover

qdbus-qt5 $dbusRef Set "" value 6
qdbus-qt5 $dbusRef setLabelText "Disabeling Boot Delay..."
#disables boot timeout
sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

qdbus-qt5 $dbusRef Set "" value 7
qdbus-qt5 $dbusRef setLabelText "Decreasing Swappiness..."
#decreases swappiness
if ! grep -Fxq "vm.swappiness=10" "/etc/sysctl.conf" ; then
  "vm.swappiness=10" >> /etc/sysctl.conf
fi

qdbus-qt5 $dbusRef Set "" value 8
qdbus-qt5 $dbusRef setLabelText "Enabling autounlock for KWallet..."
#auto unlocks KWallet
zypper --non-interactive install -y pam_kwallet

qdbus-qt5 $dbusRef Set "" value 9
qdbus-qt5 $dbusRef setLabelText "Installing Gnome Keyring..."
#installs and auto unlocks Gnome-Keyring
zypper --non-interactive install -y gnome-keyring seahorse
if ! grep -Fxq "pam_gnome_keyring.so" "/etc/pam.d/sddm" ; then
  sed -i "/common-auth/a auth	optional	pam_gnome_keyring.so" /etc/pam.d/sddm
  sed -i "/common-session/a session	optional	pam_gnome_keyring.so auto_start" /etc/pam.d/sddm
fi

qdbus-qt5 $dbusRef Set "" value 10
qdbus-qt5 $dbusRef setLabelText "Installing Snap..."
#installs snap
zypper --non-interactive addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
zypper --gpg-auto-import-keys refresh
zypper --non-interactive dist-upgrade --from snappy
zypper --non-interactive install snapd
systemctl enable --now snapd
systemctl enable --now snapd.apparmor

qdbus-qt5 $dbusRef Set "" value 11
qdbus-qt5 $dbusRef setLabelText "Installing Flatpak..."
#installs flatpak
zypper --non-interactive install -y flatpak

qdbus-qt5 $dbusRef Set "" value 12
qdbus-qt5 $dbusRef setLabelText "Updating System..."
#installs updates
zypper --non-interactive refresh
zypper --non-interactive dist-upgrade --allow-vendor-change

#closes KDialog progress window
qdbus-qt5 $dbusRef close

#closes the script
exit
