#!/bin/bash

option_user_create() {

    USERNAME=$(monolog --title "USER CREATION" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --inputbox "What you would like to name your user?" 0 0 \
    )
        [ "$?" == "3" ] && map

        option_user_password
}

option_user_password() {

    USER_PASSWORD1=$(monolog --title "USER PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Write $USERNAME's password" 0 0 \
    )

    USER_PASSWORD2=$(monolog --title "USER PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Verify $USERNAME's password" 0 0 \
    )

    if [[ "$USER_PASSWORD1" != "$USER_PASSWORD2" ]]
    then
        option_wrong_password
        option_user_password
    fi

        option_timezone
}