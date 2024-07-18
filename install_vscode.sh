#!/bin/bash
varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

latest_version=$(curl -s https://api.github.com/repos/microsoft/vscode/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget "https://update.code.visualstudio.com/${latest_version}/linux-deb-arm64/stable" -O code.deb

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./code.deb -y

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 rm code.deb

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install gpg software-properties-common apt-transport-https -y

proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt-key add -

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=VS Code
Comment=Code Editing. Redefined.
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/share/code/code --no-sandbox
Icon=visual-studio-code
Categories=Development;
Path=
Terminal=false
StartupNotify=false
" > $HOME/Desktop/code.desktop

chmod +x $HOME/Desktop/code.desktop
cp $HOME/Desktop/code.desktop $HOME/../usr/share/applications/code.desktop 