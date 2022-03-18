#!/bin/sh

# reset launchpad
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# clean Dock
defaults write com.apple.dock persistent-apps -array; killall Dock

# enable PressAndHold
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# music language
defaults write /Users/diartyz/Library/Preferences/com.apple.Music.plist AppleLanguages -array zh_CN

# allow apps from anywhere
sudo spctl --master-disable
