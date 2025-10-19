#!/bin/bash

execute_wipe() {

local type_disk=$(lsblk $DISK -d | grep -oh -E 'sd|nvme')

local frozen_check=$(hdparm -I $DISK | grep frozen)


    if [ "$WIPE_DISK" == "yes" ]
    then
        case "$type_disk" in
            sd)
                install hdparm
                if [ "$frozen_check" != "	not	frozen" ]
                then
                    monolog --title "Disk is FROZEN" --msgbox "Disk wipe cannot be continued, its okay, installation will continue"
                else
                    hdparm --user-master u --security-set-pass PasSWorD $DISK
                    hdparm --user-master u --security-erase PasSWorD $DISK 
                fi
            ;;
            nvme)
                install nvme-cli
                nvme format -s1 "$DISK"
            ;;
        esac

    fi

    case "$DISK_METHOD" in
        automatic) execute_disk_auto ;;
        manual) execute_disk_manual ;;
    esac
    
}

execute_disk_auto() {

    sfdisk --delete "$DISK"

    # 'echo ;' here is equivalent to pressing enter in fdisk
    (
        echo g; # gpt table
        echo n; echo ; echo ; echo +500M; # ESP
        [ "$SWAP_STYLE" == "partition" ] && echo n; echo ; echo ; echo +"$SWAP_SIZE";
        echo n; echo ; echo ; echo ;
        echo w;
    )| fdisk -w always "$DISK"

    if [[ "$DISK" == /dev/nvme* ]] 
    then
    PP="p"
    fi

    ESP="$DISK""$PP"1

    if [ "$SWAP_STYLE" == "partition" ]
    then
        SWAP="$DISK""$PP"2
        ROOT="$DISK""$PP"3
    else
        ROOT="$DISK""$PP"2
    fi

        execute_encryption
}


execute_disk_manual() {

    cfdisk $DISK 

    PARTITIONZ=$(lsblk -o NAME,SIZE | grep '─' | sed 's/.*─//')
    what_partition

}

what_partition() {

    if [ "$BOOTLOADER" != "none" ]
    then
        option_esp
    fi

    if [ "$SWAP_STYLE" == "partition" ]
    then
        option_swap_partition
    fi

    option_root_partition

    execute_encryption
}

option_esp() {

    if OPTION_ESP=$(monolog --title "ESP CHOOSER" \
            --no-cancel \
            --menu "Choose ESP partition that you partitioned" 0 0 0 \
            $PARTITIONZ)  
    then
        ESP="/dev/$OPTION_ESP"
    fi
}   

option_root_partition() {

    if OPTION_ROOT=$(monolog --title "ROOT CHOOSER" \
            --no-cancel \
            --menu "Choose ROOT partition that you partitioned" 0 0 0 \
            $PARTITIONZ)  
    then
        ROOT="/dev/$OPTION_ROOT"
    fi

}

option_swap_partition() {

    if OPTION_SWAP=$(monolog --title "SWAP CHOOSER" \
            --no-cancel \
            --menu "Choose SWAP partition that you partitioned" 0 0 0 \
            $PARTITIONZ)  
    then
        SWAP="/dev/$OPTION_SWAP"
    fi

}

