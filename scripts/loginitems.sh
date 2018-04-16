#!/bin/bash

defaults write loginwindow AutoLaunchedApplicationDictionary -array-add '{ "Path" = "~/Applications/Amethyst.app"; "Hide" = 0; }'
defaults write loginwindow AutoLaunchedApplicationDictionary -array-add '{ "Path" = "~/Applications/Keyboard Maestro.app"; "Hide" = 0; }'
defaults write loginwindow AutoLaunchedApplicationDictionary -array-add '{ "Path" = "~/Applications/Keyboard iTerm.app"; "Hide" = 0; }'
