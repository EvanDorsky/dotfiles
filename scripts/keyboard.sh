#!/bin/bash

keyboard_id="$(ioreg -n 'Apple Internal Keyboard / Trackpad' -r | grep -e idProduct\" -e idVendor | tr -d \"\|[:blank:] | cut -d\= -f2 | tr '\n' -)"

defaults -currentHost write -g com.apple.keyboard.modifiermapping."$keyboard_id"0 -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer><key>HIDKeyboardModifierMappingDst</key><integer>2</integer></dict>'
