#!/bin/bash

option_bootloader() {

    BOOTLOADER=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "rEFInd is more like boot option chooser\nEFI Stub will boot you automatically to system without gui\n\nIf you use more than 1 operating system choose refind" 0 0 \
      --and-widget \
    --title "BOOTLOADER" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select bootloader:" 0 0 0 \
    "refind" "" "efi stub" "" "none" ""
    )
        [ "$?" == "3" ] && map

        option_aur
}
