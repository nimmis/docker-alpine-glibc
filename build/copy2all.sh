#!/bin/sh
#
# copy file from directory to all other
#
# copy2all <source directory> <source file> 
#
# (c) 2017 nimmis <kjell.havenskold@gmail.com>
#

BASEDIR=$(dirname "$0")

if [ ! -d $BASEDIR/$1 ]; then
  echo "$1 is not a directory"
  exit 1
fi

if [ ! -f $BASEDIR/$1/$2 ]; then
  echo "file $1/$2 does not exist"
  exit 1
fi

TAGS=$(ls -1l $BASEDIR | grep ^d | grep '[0-9]\.' | grep -v $1$ | awk '{print $NF}')


for TAG in $TAGS; do

  cp $BASEDIR/$1/$2 $BASEDIR/$TAG/$2

done
