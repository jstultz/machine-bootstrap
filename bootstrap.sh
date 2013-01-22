#!/usr/bin/env bash

set -e

echo "Installing Xcode..."
curl -LO "https://s3.amazonaws.com/bootstrap-machine-installers/xcode4520418508a.dmg"
hdiutil attach xcode4520418508a.dmg
echo "Copy Xcode to the Applications folder, then press enter"
read
echo "Open Xcode from the Applications folder, then install the command line "
echo " tools. Open Preferences -> Downloads and click the Install button next "
echo " to Command Line Tools; when completed, press enter"
hdiutil detach "/Volumes/Xcode"
rm xcode4520418508a.dmg

# TODO maybe change this
# xcode-select -switch /

echo "Installing homebrew..."
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

function use_brew_version {
  prev=`pwd`
  cd /usr/local
  `brew versions $1 | grep $2 | cut -d " " -f 2-`
  cd $prev
}

# Set PATH to provide access to homebrew installs
echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile # XXX this doesn't affect the outer shell

echo "Installing gnu gcc and associated tools..."
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

# TODO maybe install qemu because i'm reaaaaaaally tired of trying to get it
# to build on mountain lion without using brew

echo "Installing virtualenv"
sudo easy_install virtualenv==1.7

echo "Generating SSH keys"
ssh-keygen -t rsa -f $HOME/.ssh/id_rsa
ssh-add $HOME/.ssh/id_rsa

echo "Please enter your gerrit username:"
read gerrit_username
echo "Host review.source.tsumobi.com" >> $HOME/.ssh/config
echo "  User $gerrit_username" >> $HOME/.ssh/config

cat $HOME/.ssh/id_rsa.pub | pbcopy
echo "Your public SSH key is now in the clipboard. Please add it to your user's"
echo "SSH public keys on Gerrit, and press enter when finished."
read

# XXX the rest of this stuff we don't really want to do on buildslaves
echo "Enter desired code directory:"
read code_path
mkdir -p $code_path
cd $code_path

echo "Retrieving code"
repo init -u ssh://review.source.tsumobi.com:29418/manifest
repo sync

# TODO still need to get web certificates
# TODO still need to setup .fog credentials
# TODO SECURE_KEY_DIR??
# TODO set ulimit
# TODO add mre/bin to path
# TODO setup gimme tab completion
