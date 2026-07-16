#!/bin/bash

defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.Dock autohide-delay -float 0.02; killall Dock
