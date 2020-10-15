#! /usr/bin/sh

#Script that brings base box to a testing ready environment

SUDO_FLAG="$(echo $(id -u))"
PASSWORD="vagrant"
BOX_USER="vagrant"
HOME="/home/$USER"
KEY_URL="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

echo "<---Bootstrap script--->"

if [[ $SUDO_FLAG -ne 0 ]]
then
    echo "not a sudo" && exit 1
fi

if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null
then
  echo "IPv4 is down" && exit 1
fi

#make ssh connection available: vagrant ssh

if [[ $(grep -c "^$BOX_USER:" /etc/passwd) -eq 0 ]]
then    
    useradd -G sudo $BOX_USER -d $HOME

    echo $PASSWORD | passwd $BOX_USER --stdin

    echo "$BOX_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant

    mkdir "$HOME/.ssh"

    chmod 0700 "$HOME/.ssh"

    wget --no-check-certificate "$KEY_KEY" -O "$HOME/.ssh/authorized_keys"

    chmod 0600 "$HOME/.ssh/authorized_keys"

    chown -R vagrant "$HOME/.ssh"

    apt update --yes && apt upgrade --yes && apt install --yes openssh-server

    sed -i /etc/ssh/sshd_config -e "/#Author*/ c AuthorizedKeysFile %h/.ssh/authorized_keys"

    sudo service ssh restart
fi

#Make shared directory mounts available

apt install -y curl ufw gcc dkms build-essential #linux-headers

#Check sensitive permissions

chown root:root /etc/fstab

chown root:root /etc/grub.conf

chmod og-rwx /etc/grub.conf

#Securing boot

sed -i "/SINGLE/s/sushell/sulogin/" /etc/sysconfig/init

sed -i "/PROMPT/s/yes/no/" /etc/sysconfig/init

echo "<---Done--->"

exit 0;