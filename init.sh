#!/bin/bash

# Enable TouchID for sudo (comment out if Mac doesn't have TouchID!)
# If this goes wrong, can only be fixed in single user mode (since it breaks sudo)
sudo (echo "auth sufficient pam_tid.so\n"; cat /etc/pam.d/sudo) > /etc/pam.d/sudo

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install useful homebrew packages
./scripts/brew.sh

# Install cask apps
./scripts/cask.sh

# Set System defaults
export DOTFILES_ROOT=".dotfiles"
# TODO

# Set app defaults
# TODO
# iTerm colors
# Sublime settings
# Keyboard Maestro settings and macros
# Per-app shortcuts
# 	Bear
# 	...
# ...

# Sublime
cp apps/sublime/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/


# Set login items
./scripts/loginitems.sh

# Fix keyboard
./scripts/keyboard.sh

# Create ssh key and add to GitHub account
./scripts/ssh.sh

# Configure git
git config --global user.name "Evan Dorsky"
git config --global user.email evan.dorsky@icloud.com
git config --global alias.l "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Set macOS defaults
./.macos

