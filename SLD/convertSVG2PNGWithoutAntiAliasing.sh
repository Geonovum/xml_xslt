#!/usr/bin/env bash

sourceDir=$1
target=$2
resolution=$3
width=$4
height=$5

if [ -z "$sourceDir" ];then
	echo "Please set directory-source for svg: the command has 5 parameters: source, target, resolution, width, heigth."
	exit 1
fi
if [ -z "$target" ];then
	echo "Please set directory-target: the command has 5 parameters: source, target, resolution, width, heigth, with params $1 is not valid."
	exit 1
fi
if [ -z "$resolution" ];then
	echo "Please set resolution: the command has 5 parameters: source, target, resolution, width, heigth, with params $1 $2 is not valid."
	exit 1
fi
if [ -z "$width" ];then
	echo "Please set width: the command has 5 parameters: source, target, resolution, width, heigth, with params $1 $2 $3 is not valid."
	exit 1
fi
if [ -z "$height" ];then
	echo "Please set height: the command has 5 parameters: source, target, resolution, width, heigth, with params $1 $2 $3 $4 is not valid."
	exit 1
fi
if [ ! -d "$sourceDir" ]; then
    echo "$sourceDir is not found or does not exist, please indicate directory where *.svg is to be found."
	exit 1
fi
if [ ! -d "$target" ]; then
    echo "$target is not found or does not exist, please indicate where the high resolution are to be written."
	exit 1
fi

cd $sourceDir
    for svg in *.svg; do
        [ -f "$svg" ] || break
        filename="${svg%.*}"
        /c/Program\ Files/GIMP\ 2/bin/gimp-console-2.10.exe -b '(let*(image(car(file-svg-load RUN-NONINTERACTIVE "$svg" $svg $resolution $width $height))drawable(car(gimp-image-get-active-layer image)))(gimp-image-convert-indexed image CONVERT-DITHER-NONE CONVERT-PALETTE-GENERATE 0 FALSE TRUE)(gimp-file-save RUN-NONINTERACTIVE image drawable $target/$filename.png $target/$filename.png ))' -b '(gimp-quit 0)' 
    done
cd -