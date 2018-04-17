#!/bin/bash

# Enable TouchID for sudo (comment out if Mac doesn't have TouchID!)
sudo (echo "auth sufficient pam_tid.so\n"; cat /etc/pam.d/sudo) > /etc/pam.d/sudo

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install useful homebrew packages
./brew.sh

# Install cask apps
./cask.sh

# Set macOS defaults
./.macos

# Set custom defaults
export DOTFILES_ROOT=".dotfiles"
# magic goes here

# Set login items
./scripts/loginitems.sh

# Fix keyboard
./scripts/keyboard.sh

# Create ssh key and add to GitHub account
./scripts/ssh.sh

# Configure git
git config --global user.name "Evan Dorsky"
git config --global user.email evan.dorsky@icloud.com
