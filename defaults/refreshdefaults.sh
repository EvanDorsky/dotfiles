#!/bin/bash

defaults read NSGlobalDomain > "$HOME"/"$DOTFILES_ROOT"/defaults/NSGlobalDomain.defaults
defaults -currentHost read NSGlobalDomain > "$HOME"/"$DOTFILES_ROOT"/defaults/NSGlobalDomain-currentHost.defaults
