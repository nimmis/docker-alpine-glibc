#!/bin/sh
#
# build script for docker
#
# run as 
# build.sh <repository name> <tag>
#
# (c) 2017 nimmis <kjell.havneskold@gmail.com>
#

# get basedirectory

BASEDIR=$(dirname "$0")

# file for log output from build

TMPFILE=$(echo $1 |sed "s./._.g")
TMPFILE="/tmp/$TMPFILE.log"

CONTAINER=$1
TAG=$2

showhelp() {
  echo
  echo "build.sh <repository name> <tag>"
  echo "build a container and test if it works"
  echo "<tag> must match a sub-directory"
  exit 1
}

if [ -z $1 ]; then
  echo "repository name no defined"
  showhelp
fi

remove_old_container() {

  # find out if there is a container

  docker images | grep ^$CONTAINER\ | grep -q " $TAG "

  if [ "$?" = "0" ]; then
    echo "Remove old container"

    RET=$(docker rmi $CONTAINER:$TAG 2>&1)

    if [ ! "$?" = "0" ]; then
      echo "FAILED to remove old container, ERR:$RET"
      exit 1
    fi
  fi 
}

EXITVAL=0 

if [ -n "$2" ]; then

  BUILDPATH=$2

  # check to see if there is a Dockerfile there

  if [ -e $BUILDPATH/Dockerfile ]; then

    #remove any previous build of this container

    remove_old_container

    printf "Starting to build %30s .. " "$1:$2"

    docker build --pull -t "$1:$2"  $BUILDPATH/ > $TMPFILE 2>&1

    if [ "$?" = "0" ]; then

      echo "SUCCESS"

      # remove logfile from build
      rm $TMPFILE

    else

      echo "FAILED, see $TMPFILE for more information"
      exit 1

    fi

  else

    echo "Error: tag $1 is not a defined build"
    showhelp

  fi

else

  echo "No tag supplied"
  showhelp

fi

