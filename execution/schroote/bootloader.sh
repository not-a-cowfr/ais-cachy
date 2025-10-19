#!/bin/bash

execute_bootloader() {

    if [ "$SWAP_STYLE" == "partition" ]
    then
        SWAP_RESUME="resume=$SWAP"
    fi

    if [ "$FILESYSTEM" == "btrfs" ]
    then
        ROOTFLAG="rootflags=subvol=/@"
    fi

    case $BOOTLOADER in
    refind) execute_refind ;;
    "efi stub") execute_efi_stub ;;
    esac

        execute_end
}

execute_refind() {

    refind-install --usedefault "$ESP" --alldrivers
    mkrlconf

cat > /boot/refind_linux.conf << EOF 
"Boot with minimal options"   "root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img $INIT_UCODE rw add_efi_memmap quiet $NVIDIA_MODESET"
EOF
}

execute_efi_stub() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB" \
 --loader /vmlinuz-$KERNEL \
 --unicode "root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img $INIT_UCODE rw quiet $NVIDIA_MODESET"   

}


