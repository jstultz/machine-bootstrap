#!/bin/bash

# :TODO
#  . make so no keyboard commands are needed
#  . find a way to securely install/distribute credentials
sudo echo "starting bootstrap install of dev machine dependencies" &&
echo "installing xcode" &&
hdiutil attach xcode44cltools_10_86938106a.dmg &&
sudo installer -pkg "/Volumes/Command Line Tools (Mountain Lion)/Command Line Tools (Mountain Lion).mpkg" -target / &&
hdiutil detach "/Volumes/Command Line Tools (Mountain Lion)" &&
echo "installed command line tools" &&

echo "installing homebrew from tsumobi repository" &&
ruby -e "$(curl -fsSL https://raw.github.com/gist/1590468/ed994e512aea043812c33edabf4ee02b6d977ef7)" &&

echo "installing package dependencies" &&
brew install ruby &&
brew install git &&
brew install --HEAD repo &&
brew install wget &&
brew install gnu-tar &&
brew install bash-completion &&
sudo easy_install virtualenv==1.7 &&
echo "installed packaged dependencies" &&

echo "adding ruby and homebrew to bash profile" &&
echo "export PATH=$HOME/bin:/usr/local/bin:/usr/local/Cellar/ruby/1.9.2-p180/bin:$PATH" >> ~/.bash_profile &&

echo "install homebrew and bash completion" &&
ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d" &&
echo "  if [ -f `brew --prefix`/etc/bash_completion ]; then" >> ~/.bash_profile &&
echo "    . `brew --prefix`/etc/bash_completion" >> ~/.bash_profile &&
echo "  fi" >> ~/.bash_profile &&
echo "setting ulimit to unlimited!" &&
echo "ulimit -n 8192" >> ~/.bash_profile &&
source ~/.bash_profile &&
echo "bash profile upgraded and sourced" &&

echo "generating ssh keys"
ssh-keygen -t rsa &&

echo "installing virtualbox" &&
hdiutil attach VirtualBox-4.1.18-78361-OSX.dmg &&
sudo installer -pkg "/Volumes/VirtualBox/VirtualBox.mpkg" -target / &&
hdiutil detach "/Volumes/VirtualBox" &&
echo "Installed Virtualbox" &&

echo "Installing SublimeText 2" &&
hdiutil attach "Sublime Text 2.0.1.dmg" &&
cp -R "/Volumes/Sublime Text 2/Sublime Text 2.app" /Applications && 
hdiutil detach "/Volumes/Sublime Text 2" &&
echo "Installed Sublime Text 2" &&


echo " " &&
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" &&
echo "XXXX  1) You still need to add keys to Gerrit, chump.  XXXX" &&
echo "XXXX  2) After that you can repo checkout to ~/code.   XXXX" &&
echo "XXXX  3) Now set up your .fog credentials for aws      XXXX" &&
echo "XXXX  4) if all is well,                               XXXX" &&
echo "XXXX       cd ~/code/tools/review/infrastructure       XXXX" &&
echo "XXXX       ./build dev                                 XXXX" &&
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 