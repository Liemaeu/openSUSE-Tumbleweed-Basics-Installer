#!/usr/bin/env bash

#opens KDialog window
kdialog --title "openSUSE Basics Installer" --yesno "Install?"
if [ $? -eq 1 ]; then
    exit
fi

#runs commands as root
kdesu ./Root-Commands.sh

#opens KDialog progress window
dbusRef=`kdialog --title "Final steps, please wait" --progressbar "Starting..." 2`
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
qdbus-qt5 $dbusRef setLabelText "Setting up Flatpak..."
#sets up flatpak
flatpak update

#closes KDialog progress window
qdbus-qt5 $dbusRef close

#shows finished message
kdialog --msgbox "Finished!"

#closes the script
exit
