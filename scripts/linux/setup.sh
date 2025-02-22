#!/usr/bin/env bash

# [[ System settings ]]

# Btrfs subvolumes
for dir in /var/lib/machines /var/lib/portables /var/lib/libvirt; do
    if [ -d "$dir" ]; then
        sudo cp -a "$dir" "$dir.bak"
        sudo rm -rf "$dir"
        sudo btrfs subvolume create "$dir"
        sudo cp -a "$dir.bak/." "$dir/"
        sudo rm -rf "$dir.bak"
    else
        sudo btrfs subvolume create "$dir"
    fi
    sudo chattr +C "$dir"
done

# Dual boot clock
sudo timedatectl set-local-rtc 1

# [[ Applications ]]

# Packages
sudo dnf remove -y \
  @firefox \
  @libreoffice \
  libreoffice*

sudo dnf install -y \
  alacritty \
  gparted \
  timeshift \
  wl-clipboard \
  zsh

# Default shell
chsh -s /bin/zsh

# NVIDIA drivers
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

# Docker
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd -f docker
sudo usermod -aG docker "$USER"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
  | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update && sudo dnf install -y code

# Flatpaks
flatpak remote-modify --disable fedora
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub org.gnome.World.PikaBackup
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.mozilla.firefox

# [[ Desktop environment ]]

# Gnome
# alphabetical app grid / tiling shell
for i in $(seq 1 9); do gsettings set org.gnome.shell.keybindings switch-to-application-"${i}" "[]"; done
for i in $(seq 1 9); do gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"${i}" "['<Super>${i}']"; done
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>J']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>K']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Shift><Super>J']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Shift><Super>K']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.shell.window-switcher current-workspace-only false
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat

# [[ Nix ]]

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager/master -- switch --flake ~/Repos/home-manager#linux
