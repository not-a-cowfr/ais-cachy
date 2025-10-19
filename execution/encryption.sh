#!/bin/bash

execute_encryption() { 
    if [ "$ENCRYPTION" == "yes" ] 
    then

        clear 
        echo "Wait For encryption to end"

        [ -z "$hash" ] &&
            hash="sha512"

        [ -z "$keysize" ] &&
            keysize="512"

        [ -z "$itertime" ] &&
            itertime="10000"

                    echo "$ENCRYPTION_PASSWORD1
                $ENCRYPTION_PASSWORD2
                " | cryptsetup luksFormat --type luks2 --batch-mode --verify-passphrase --hash "$hash" --key-size "$keysize" --iter-time "$itertime" --pbkdf argon2id --use-urandom "$ROOT" 
        
        echo "$ENCRYPTION_PASSWORD1" | cryptsetup luksOpen "$ROOT" artix 

    fi
CRYPT="/dev/mapper/artix"

        execute_lvm
}