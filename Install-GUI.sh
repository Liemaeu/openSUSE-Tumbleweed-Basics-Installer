#!/usr/bin/env bash

#opens KDialog window
kdialog --title "openSUSE Basics Installer" --yesno "Install?"
if [ $? -eq 1 ]; then
    exit
fi

#runs commands as root
kdesu ./Root-Commands.sh

#opens KDialog progress window
dbusRef=`kdialog --title "Final steps, please wait" --progressbar "Starting..." 4`
qdbus-qt5 $dbusRef showCancelButton false

qdbus-qt5 $dbusRef Set "" value 1
qdbus-qt5 $dbusRef setLabelText "Making YaST Software default for .rpm..."
#sets YaST Software as default application for .rpm
if ! [ -f "$HOME/.config/mimeapps.list" ]; then
  echo "[Default Applications]" > $HOME/.config/mimeapps.list
fi
if ! grep -Fxq "application/x-rpm=org.opensuse.yast.Packager.desktop;" "$HOME/.config/mimeapps.list" ; then
  sed -i "/Default Applications/a application/x-rpm=org.opensuse.yast.Packager.desktop;" $HOME/.config/mimeapps.list
fi

qdbus-qt5 $dbusRef Set "" value 2
qdbus-qt5 $dbusRef setLabelText "Removing Discover icon from taskbar..."
#removes Discover icon from the taskbar
if ! grep -Fxq "[Containments][2][Applets][5][Configuration][General]" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ; then
  echo "" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "[Containments][2][Applets][5][Configuration][General]" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "launchers=applications:systemsettings.desktop,preferred://filemanager,preferred://browser" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
fi

qdbus-qt5 $dbusRef Set "" value 3
qdbus-qt5 $dbusRef setLabelText "Setting search for updates to weekly..."
if ! grep -Fxq "[Containments][9][Applets][10][Configuration][General]" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ; then
  echo "" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "[Containments][9][Applets][10][Configuration][General]" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "daily=false" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
  echo "weekly=true" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
fi

qdbus-qt5 $dbusRef Set "" value 4
qdbus-qt5 $dbusRef setLabelText "Setting up Flatpak..."
#sets up flatpak
flatpak update

#closes KDialog progress window
qdbus-qt5 $dbusRef close

#shows finished message
kdialog --msgbox "Finished! Please reboot."

#closes the script
exit
