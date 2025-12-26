#!/bin/bash

SOURCES=$(ls /mnt/schroote/ -I chroot.sh -I modules )

for i in $SOURCES
do
	source /mnt/schroote/"$i"
done

	sed -i 's/^CheckSpace/#CheckSpace/' /etc/pacman.conf

	rankmirrors -v -n 5 /etc/pacman.d/mirrorlist

	touch $SSHELL_CONFIG

execute_root_password


