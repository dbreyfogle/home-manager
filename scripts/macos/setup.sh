#!/usr/bin/env bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "/Users/$USER/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --file ~/Repos/home-manager/scripts/macos/Brewfile
sudo ln -sf /opt/homebrew/opt/coreutils/bin/gls /usr/local/bin/ls

# Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager/master -- switch --flake ~/Repos/home-manager#macos
