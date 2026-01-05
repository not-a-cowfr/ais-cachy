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

    if [ "$ENCRYPTION" == "yes" ]
    then
        ROOT_BLKID=$(blkid -s UUID -o value $ROOT)
            ENCRYPTED_ROOT="rd.luks.name=$ROOT_BLKID=Artix"
    fi

	KERNEL_PARAMETERS="$ENCRYPTED_ROOT root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img $INIT_UCODE rw add_efi_memmap quiet $NVIDIA_MODESET"

    for i in $BOOTLOADER;
    do
	    execute_$i
	done

        execute_end
}

execute_refind() {

    refind-install --usedefault "$ESP" --alldrivers
    mkrlconf

cat > /boot/refind_linux.conf << EOF 
"Boot with minimal options"   "$KERNEL_PARAMETERS"
EOF
}

execute_efistub() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB" \
 --loader /vmlinuz-$KERNEL \
 --unicode "${KERNEL_PARAMETERS}"   

}

execute_efistub-fallback() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB-fallback" \
 --loader /vmlinuz-$KERNEL \
 --unicode "initrd=\booster-$KERNEL-universal.img"   

}
