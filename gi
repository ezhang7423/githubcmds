#!/bin/bash

mkdir $1
cd $1
git init
echo "# $1" > README.md
git add .
git commit -m "initial commit"
hub create
git push --set-upstream origin master
