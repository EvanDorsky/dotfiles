#!/bin/bash

brew install zsh
sudo dscl . -create /Users/$USER UserShell $(brew prefix)/bin/zsh
