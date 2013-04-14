#!/bin/bash

script_dir=$(cd $(dirname $0); pwd)

force=0
while getopts f OPT
do
    case $OPT in
	"f" ) force=1 ;;
	 *  )
	    echo "usage : $0 [-f]" 2>&1
	    exit 1
	    ;;
    esac
done

for file in `echo dot.*`
do
    srcfile=$script_dir/$file
    dstfile=$HOME/$(echo $file | sed -e 's/^dot//g')

    if [ -e $dstfile -o -L $dstfile ]; then
	if [ $force -eq 0 ]; then
	    echo "File exists : $dstfile"
	    continue
	fi
	rm -rf $dstfile
    fi

    ln -s $srcfile $dstfile
done
