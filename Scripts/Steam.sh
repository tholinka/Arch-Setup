#!/bin/sh
echo "Need 32bit version of graphics card libraries: lib32-mesa for AMD/Intel, lib32-nvidia-utils for nvidia"
echo "Also fonts will look bad / not be there if you haven't installed the better fonts"

sudo pacman -S --needed \
steam