#!/bin/bash

execute_graphics() {

    for i in $GRAPHICS
    do
        case $i in
        amd) install mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver ;;
        
        intel) install mesa xf86-video-intel vulkan-intel ;;

        nouveau) install mesa xf86-video-nouveau vulkan-nouveau  ;;

        nvidia-open) 
            case $KERNEL in 
                linux) install nvidia-open nvidia-utils ;;
                linux-lts) install nvidia-open-lts nvidia-utils ;;
                linux-zen) install nvidia-open-dkms nvidia-utils ;;
            esac
            echo "modules_force_load: nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" >> /etc/booster.yaml
            /usr/lib/booster/regenerate_images
            NVIDIA_MODESET="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
        ;;

        nvidia) 
            case $KERNEL in 
                linux) install nvidia nvidia-utils ;;
                linux-lts) install nvidia-lts nvidia-utils ;;
                linux-zen) install nvidia-dkms nvidia-utils ;;
            esac
            echo "modules_force_load: nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" >> /etc/booster.yaml
            /usr/lib/booster/regenerate_images
            NVIDIA_MODESET="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
        ;;

        nvidia-470) su $USERNAME << 'EOF'
        source /mnt/schroote/variables.sh
        install_aur nvidia-470xx-dkms nvidia-470xx-utils
EOF
        echo "modules_force_load: nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" >> /etc/booster.yaml
        /usr/lib/booster/regenerate_images
        NVIDIA_MODESET="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
        ;;

        nvidia-390) su $USERNAME << 'EOF'
        source /mnt/schroote/variables.sh
        install_aur nvidia-390xx-dkms nvidia-390xx-utils
EOF
        echo "modules_force_load: nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" >> /etc/booster.yaml
        /usr/lib/booster/regenerate_images
        NVIDIA_MODESET="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
         ;;
        esac
    done
 
    if [[ "$GRAPHICS" =~ nvidia ]]
    then
echo '#!/bin/sh

case "$1" in
    pre)
        /usr/bin/nvidia-sleep.sh "suspend"
        ;;
    post)
        /usr/bin/nvidia-sleep.sh "resume"
        ;;
esac' > /lib64/elogind/system-sleep/nvidia
 	SWAY_GPU="--unsupported-gpu"
    fi

        execute_modules
}
