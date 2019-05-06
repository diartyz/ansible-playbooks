#!/bin/sh

# reset launchpad
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# clean Dock
defaults write com.apple.dock persistent-apps -array; killall Dock

# enable PressAndHold
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
