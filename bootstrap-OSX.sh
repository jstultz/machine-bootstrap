#!/bin/bash

# :TODO
# . make so no keyboard commands are needed
# . find a way to securely install/distribute credentials
# . FIX $path var to not be evaluated when added to bash_profile
# . pstree and watch
echo "need sudo to install necessary dependencies..." &&
sudo echo "starting bootstrap install of dev machine dependencies" &&
echo "downloading and installing xcode" &&
if [[ `uname -r` ==  12* ]]
then
    echo "discovered mountain lion as os version" &&
    curl -LO "http://bootstrap-machine-installers.s3.amazonaws.com/xcode44cltools_10_76938107a.dmg" &&
    hdiutil attach xcode44cltools_10_86938106a.dmg &&
    sudo installer -pkg "/Volumes/Command Line Tools (Mountain Lion)/Command Line Tools (Mountain Lion).mpkg" -target / &&
    hdiutil detach "/Volumes/Command Line Tools (Mountain Lion)" &&
    echo "installed command line tools for mountain lion"
else
    echo "assuming lion since mountain lion not discovered" &&
    curl -LO "http://bootstrap-machine-installers.s3.amazonaws.com/cltools_lion_march12.dmg" &&
    hdiutil attach cltools_lion_march12.dmg &&
    sudo installer -pkg "/Volumes/Command Line Tools/Command Line Tools.mpkg" -target / &&
    hdiutil detach "/Volumes/Command Line Tools" &&
    echo "installed command line tools for lion" &&
    echo "install gcc package 4.2 for lion" &&
    curl -LO "https://github.com/downloads/jcliff/osx-gcc-installer/GCC-10.7-v2.pkg" &&
    sudo installer -pkg GCC-10.7-v2.pkg -target / &&
    echo "installed gcc 4.2 for lion."
fi

echo "installing homebrew from tsumobi repository" &&
ruby -e "$(curl -fsSL https://raw.github.com/gist/1590468/ed994e512aea043812c33edabf4ee02b6d977ef7)" &&
echo "installed homebrew!" &&

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
echo 'export PATH=$HOME/bin:/usr/local/bin:/usr/local/Cellar/ruby/1.9.2-p180/bin:$PATH' >> ~/.bash_profile &&

echo "install homebrew and bash completion" &&
ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d" &&
echo '  if [ -f `brew --prefix`/etc/bash_completion ]; then' >> ~/.bash_profile &&
echo '    . `brew --prefix`/etc/bash_completion' >> ~/.bash_profile &&
echo '  fi' >> ~/.bash_profile &&
echo "setting ulimit to unlimited!" &&
echo "ulimit -n 8192" >> ~/.bash_profile &&
source ~/.bash_profile &&
echo "bash profile upgraded and sourced" &&

echo "generating ssh keys" &&
ssh-keygen -t rsa &&

echo "downloading and installing virtualbox" &&
curl -LO "http://bootstrap-machine-installers.s3.amazonaws.com/VirtualBox-4.1.18-78361-OSX.dmg" &&
hdiutil attach VirtualBox-4.1.18-78361-OSX.dmg &&
sudo installer -pkg "/Volumes/VirtualBox/VirtualBox.mpkg" -target / &&
hdiutil detach "/Volumes/VirtualBox" &&
echo "Installed Virtualbox" &&

echo "downloading and installing SublimeText 2" &&
curl -LO "http://bootstrap-machine-installers.s3.amazonaws.com/Sublime_Text_2.0.1.dmg" &&
hdiutil attach "Sublime_Text_2.0.1.dmg" &&
cp -R "/Volumes/Sublime Text 2/Sublime Text 2.app" /Applications &&
hdiutil detach "/Volumes/Sublime Text 2" &&
echo "Installed Sublime Text 2" &&

echo " " &&
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" &&
echo "XXXX  1) You still need to add keys to Gerrit, chump.            XXXX" &&
echo "XXXX  2) After that you can repo checkout to ~/code.             XXXX" &&
echo "XXXX  2) After that you can repo checkout to ~/code.             XXXX" &&
echo "XXXX  cd code                                                    XXXX" &&
echo "XXXX repo init -u ssh://review.source.tsumobi.com:29418/manifest XXXX" &&
echo "XXXX  3) Now set up your .fog credentials for aws                XXXX" &&
echo "XXXX  4) if all is well,                                         XXXX" &&
echo "XXXX       cd ~/code/tools/review/infrastructure                 XXXX" &&
echo "XXXX       ./build dev                                           XXXX" &&
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 