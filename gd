#!/bin/bash

user="${user:-$(git config --get user.name)}"
echo "hub delete -y $user/$1" | bash
rm -r $1
echo "Deleted $1"

