#!/bin/bash

current="$(ls)"

if [[ $current == *"gd"* ]] && [[ $current == *"gi"* ]] && [[ $current == *"gr"* ]]; then
    if [ -z "$(command -v go)" ]; then    
        sudo add-apt-repository ppa:longsleep/golang-backports
        sudo apt update
        sudo apt install golang-go
    fi
    if [ -z "$(command -v git)" ]; then    
        sudo apt install git
    fi
    if [ -z "$(command -v hub)" ]; then    
        echo "hub doesn't exist. Download at https://github.com/github/hub/releases"
    fi
    commands=(gd gi gp gr gc)

    for i in "${commands[@]}"; 
        do sudo cp "$i" /usr/bin;
    done
fi

echo "All done! You can delete this folder now"