#!/bin/bash

keyboard_id=$(ioreg -n 'Apple Internal Keyboard / Trackpad' -r | grep -e idVendor -e idProduct | tail -r | sed 's/.*= //' | tr '\n' -)
defaults -currentHost write -g com.apple.keyboard.modifiermapping."$keyboard_id"0 -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer><key>HIDKeyboardModifierMappingDst</key><integer>2</integer></dict>'
