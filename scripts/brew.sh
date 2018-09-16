#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen

# Install other useful binaries.
brew install imagemagick --with-webp
brew install rename
brew install tree
brew install stow

# And more
brew install ag
brew install htop
brew install ranger
brew install autojump

# System Python is hell
brew install python
brew install python@2

# Remove outdated versions from the cellar.
brew cleanup
