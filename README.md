# openSUSE-Tumbleweed-Basics-Installer

This script installs and sets up everything a normal user needs. It is designed for **openSUSE Tumbleweed** with the **KDE Plasma** desktop environement on a regular **64 bit** pc (x86_64 architecture).

# Download

Download [this](https://github.com/Liemaeu/openSUSE-Tumbleweed-Basics-Installer/releases/download/1.5/openSUSE.Tumbleweed.Basics.Installer.1.5.tar.gz), extract it, open the extracted folder **openSUSE Tumbleweed Basics Installer 1.5**, click on **Install.sh** and **Execute**.

---

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
- CUPS
- 7-Zip

## Sets

- Kwallet autounlock enabled
- Gnome Keyring autounlock enabled
- boot delay disabled
- hides acpi errors and white line on boot
- firewall zone to trusted
- swappiness to 10
- YaST Software as default application for .rpm
- search for updates to weekly
- disable allow blocking of compositing
- allows vendor change

## Removes

- YaST Online Update module

---

# Run this script

Download [this](https://github.com/Liemaeu/openSUSE-Tumbleweed-Basics-Installer/releases/download/1.4/openSUSE.Tumbleweed.Basics.Installer.1.4.tar.gz), extract it, open the extracted folder **openSUSE Tumbleweed Basics Installer 1.4**, click on **Install.sh** and **Execute**.



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

# To Do after running this script

- Reboot your pc
