#!/bin/bash

set -e



commands=(gd gi gp gr gc)


for i in "${commands[@]}"; 
        do $1 ;
        #do sudo cp "$i" /usr/bin;
done