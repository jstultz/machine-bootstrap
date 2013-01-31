#!/usr/bin/env bash
source $(dirname ${BASH_SOURCE[0]})/bootstrap.sh

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

echo "Enter desired code directory:"
read code_path
mkdir -p $code_path
cd $code_path

echo "Retrieving code"
repo init -u ssh://review.source.tsumobi.com:29418/manifest
repo sync


echo "Please enter desired path for keys directory:"
read keys_dir
echo "export SECURE_KEY_DIR=$keys_dir" >> $HOME/.bash_profile

# Make gimme easy to use
echo "export PATH=$code_path/mre/bin:\$PATH" >> $HOME/.bash_profile
echo "source $code_path/gimme/scripts/gimme-completion.sh" >> $HOME/.bash_profile

# TODO still need to get web certificates
# TODO still need to setup .fog credentials
