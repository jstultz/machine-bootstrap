#!/usr/bin/env bash

set -e

echo "Installing Xcode"
curl -LO "https://s3.amazonaws.com/bootstrap-machine-installers/xcode4520418508a.dmg"
hdiutil attach xcode4520418508a.dmg
echo "Copy Xcode to the Applications folder, then press enter"
read
echo "Open Xcode from the Applications folder, then install the command line "
echo " tools. Open Preferences -> Downloads and click the Install button next "
echo " to Command Line Tools; when completed, press enter"
read
hdiutil detach "/Volumes/Xcode"
rm xcode4520418508a.dmg

echo "Installing homebrew"
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

function use_brew_version {
  prev=`pwd`
  cd /usr/local
  `brew versions $1 | grep $2 | cut -d " " -f 2-`
  cd $prev
}

# Set PATH to provide access to homebrew installs
echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH' >> $HOME/.bash_profile
echo 'ulimit -n 8192' >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "Installing gnu gcc and associated tools"
brew tap homebrew/dupes
use_brew_version autoconf 2.69
use_brew_version automake 1.13.1
brew install autoconf automake apple-gcc42

echo "Installing ruby"
use_brew_version ruby 1.9.2-p180
brew install --use-gcc --env=std ruby

echo "Installing git"
use_brew_version git 1.8.1.1
brew install git

echo "Installing repo"
use_brew_version repo 1.19
brew install repo

echo "Installing wget"
use_brew_version wget 1.12
brew install wget

echo "Installing gnu-tar"
use_brew_version gnu-tar 1.26
brew install gnu-tar

echo "Installing gpg"
brew install gpg

echo "Installing virtualenv"
sudo easy_install virtualenv==1.7
