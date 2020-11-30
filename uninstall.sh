#!/bin/bash

commands=(gd gi gp gr gc)

for i in "${commands[@]}"; 
    do sudo rm /usr/bin/"$i";
done


echo "Successfully uninstalled"