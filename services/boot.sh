#! /usr/bin/sh

chown root:root /etc/fstab

chown root:root /etc/grub.conf

chmod og-rwx /etc/grub.conf

sed -i "/SINGLE/s/sushell/sulogin/" /etc/sysconfig/init

sed -i "/PROMPT/s/yes/no/" /etc/sysconfig/init

exit 0;