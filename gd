#!/bin/bash


echo "hub delete -y ezhang7423/$1" | bash
rm -r $1
echo "Deleted $1"

