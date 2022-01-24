# openSUSE-Tumbleweed-Basics-Installer

This script installs and sets up everything a normal user needs. It is designed for **openSUSE Tumbleweed** with the **KDE Plasma** desktop environement on a regular **64 bit** pc (x86_64 architecture).

# Features

## Adds

- Packman community repository

## Installs

- media codecs
- Microsoft fonts
- Gnome Keyring (with Seahorse gui)
- Flatpak
- Snap
- build tools

## Sets

- Kwallet autounlock enabled
- Gnome Keyring autounlock enabled
- boot delay disabled
- swappiness to 10

## Fixes

- multiple package installers (Discover removed)
- YaST Software as default application for .rpm

# Run this script

Download [this](https://github.com/Liemaeu/openSUSE-Tumbleweed-Basics-Installer/releases/download/1.2/openSUSE.Tumbleweed.Basics.Installer.1.2.tar.gz), extract it, open the extracted folder **openSUSE Tumbleweed Basics Installer 1.2**, click on **Basics Installer.sh** and **Execute**.

Alternatively you can download the source code, extract it and open a terminal (e.g. Konsole) in the folder with the Install.sh script:

```
chmod +x Install.sh
./Install.sh
```

Or you can run the gui (KDialog) version:

```
chmod +x Install-GUI.sh
chmod +x Root-Commands.sh
./Install-GUI.sh
```

# ToDo after running this script

- Reboot your pc
- It's recommended to remove the Discover icon from the control panel, since it has no use anymore
