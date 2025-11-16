#!/bin/bash

#very dirty file, i will have to clean it

execute_end() {

	echo "$USER_PASSWORD1" | sudo -u $USERNAME chsh -s $(which $SSHELL)

    if [ "$SUPER" == "doas" ]
    then
        echo -e 'permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel
permit nopass :wheel as root cmd reboot
permit nopass :wheel as root cmd poweroff
permit nopass :wheel as root cmd shutdown
permit nopass :wheel as root cmd zzz' > /etc/doas.conf

	echo -e 'alias reboot="doas reboot"
alias poweroff="doas poweroff"
alias shutdown="doas shutdown"
alias zzz="doas zzz" ' >> $SSHELL_CONFIG

	sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/g' /etc/makepkg.conf

    else
        sed -i "s|$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL|%wheel ALL=(ALL) ALL|" /etc/sudoers
    fi

    if [ "$LOGIN" != "none" ]
    then
        case "$LOGIN" in
            sddm) install sddm sddm-$INIT ;;
            greetd) install greetd greetd-$INIT greetd-tuigreet
		sed -i "s|vt = 1|vt = 7|" /etc/greetd/config.toml
	
#yet another big mess i will clear it up later
      if [ "$DESKTOP" == "sway" ] && [ "$SWAY_GPU" == "yes" ]
      then
    sed -i 's|agreety --cmd /bin/sh|tiogreet -r -t --cmd sway --unsupported-gpu' /etc/greetd/config.toml
      else
    sed -i 's|agreety --cmd /bin/sh|tuigreet -r -t --cmd $DESKTOP|' /etc/greetd/config.toml
        
  fi ;;
    esac
        service "$LOGIN"
    fi

  if [ "$SWAP_STYLE" == "file" ]
  then
      swapon /swapfile
  fi


  }

