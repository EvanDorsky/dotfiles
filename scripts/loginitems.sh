#!/bin/bash

osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Amethyst.app", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Keyboard Maestro.app/Contents/MacOS/Keyboard Maestro Engine.app", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/iTerm.app", hidden:false}'
